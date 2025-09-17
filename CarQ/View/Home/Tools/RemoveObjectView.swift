//
//  RemoveObjectView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 08/09/25.
//

import Foundation
import SwiftUI
import PhotosUI

struct RemoveObjectView: View {
    var onBack: () -> Void
    
    // Image selection states
    @State private var showUploadSheet = false
    @State private var targetPhotoItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage?
    @State private var showCameraPicker = false
    @State private var showPhotoPicker = false
    
    @State private var showCameraPermissionAlert = false
    @State private var cameraDeniedOnce = false
    
    @State private var showToast = false

    @State private var resultImage: UIImage?
    @State private var isGenerated = false
    @State private var loadingPercentage = 0
    @State private var showPromptBox = false
   
    // Brush states - using the shared enum now
    @State private var brushedAreas = [CGRect]()
    @State private var currentTool: DrawingTool = .brush // Using shared enum
    @State private var brushSize: CGFloat = 20
    @State private var imageFrame: CGRect = .zero
    @State private var needsRedraw = false
    
    @State private var activeAlert: AlertType?
    @State var isProcessing: Bool = false
    @StateObject private var viewModel = GenerationViewModel()
    
    var body: some View {
        VStack {
            HeaderView(text: "Remove Object", onBack: {
                onBack()
            },onClose: {
                
            },isCross: false)
            .padding(.top, ScaleUtility.scaledSpacing(15))
            
            
            mainBrushInterface()
            
            
            Spacer()
            
            GenerateButtonView(isDisabled: brushedAreas.isEmpty ? true : false , action: {
                if brushedAreas.isEmpty {
                    activeAlert = .processingError(message: "Please brush areas you want to modify")
                } else {
                    isProcessing = true
                }
            })
        }
        // Add below your existing modifiers in body:
        .navigationDestination(isPresented: $isProcessing) {
            
            ProcessingView(
                viewModel: viewModel,
                onBack: {
                    if viewModel.shouldReturn {
                        activeAlert = .processingError(message: viewModel.errorMessage ??  "Generation failed. Please try again.")
//                        showPopUp = false
                        isProcessing = false
                   
                        withAnimation { showToast = true }
                
                        viewModel.shouldReturn = false
                    }
                    else {
//                        showPopUp = false
                        isProcessing = false

                    }
                },
                onAppear: {
                    Task {
                        guard let originalImage = selectedImage,
                              let maskImage = createMaskImage()
                        else {
                            viewModel.errorMessage = "Failed to create mask image"
                            viewModel.shouldReturn = true
                            return
                        }

                        let finalPrompt = PromptBuilder.buildRemoveObjectPrompt(objectHints: ["headlights"])
                        viewModel.currentKind = .edited
                        viewModel.currentSource = "MagicalModificationView"
                        viewModel.currentPrompt = finalPrompt          // ← add this
                        let started = await viewModel.startRemoveJob(
                            image: originalImage,
                            maskImage: maskImage,
                            prompt: finalPrompt
                        )

                        if started {
                            await viewModel.pollUntilReady()
                        } else {
                            viewModel.shouldReturn = true
                        }
                    }
                }, onClose: {
                    onBack()
                }
            )
            .background(Color.secondaryApp.edgesIgnoringSafeArea(.all))
        }

        .onChange(of: targetPhotoItem) { newItem in
            Task {
                if let newItem = newItem {
                    if let data = try? await newItem.loadTransferable(type: Data.self) {
                        if let image = UIImage(data: data) {
                            selectedImage = image
                            resetDrawing()
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showUploadSheet) {
            UploadImageSheetView(showSheet: $showUploadSheet,
                                 onCameraTap: {
                showUploadSheet = false
                Task { @MainActor in
                    if await CameraAuth.requestIfNeeded() {
                        try? await Task.sleep(nanoseconds: 300_000_000)
                        showCameraPicker = true
                        
                    } else {
                        cameraDeniedOnce = (CameraAuth.status() != .notDetermined)
                        try? await Task.sleep(nanoseconds: 300_000_000)
                        showCameraPermissionAlert = true
                    }
                }
            },
                                 onGalleryTap: {
                showUploadSheet = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    showPhotoPicker = true
                    
                }
            })
            .presentationDetents([.height( isIPad ? 410 : 210)])
            .presentationCornerRadius(20)
         
        }
        .fullScreenCover(isPresented: $showCameraPicker) {
            ImagePicker(sourceType: .camera) { image in
                selectedImage = image
                resetDrawing()
            }
        }
        .alert(item: $activeAlert) { alertType in
            switch alertType {
            case .saveResult(let message):
                return Alert(
                    title: Text("Save Result"),
                    message: Text(message),
                    dismissButton: .default(Text("OK"))
                )
            case .processingError(let message):
                return Alert(
                    title: Text("Error"),
                    message: Text(message),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .photosPicker(isPresented: $showPhotoPicker, selection: $targetPhotoItem, matching: .images)
        .ignoresSafeArea(.container, edges: [.bottom])
        .toolbar(.hidden, for: .navigationBar)
        .ignoresSafeArea(.keyboard)
        .navigationBarHidden(true)
        .background(Color.secondaryApp.edgesIgnoringSafeArea(.all))
        .alert("Camera Access Needed", isPresented: $showCameraPermissionAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Open Settings") { if let url = URL(string: UIApplication.openSettingsURLString) { UIApplication.shared.open(url) } }
        } message: {
            Text("Please enable Camera access in Settings to take a photo.")
        }

    }
    
    private func mainBrushInterface() -> some View {
        VStack(spacing: ScaleUtility.scaledSpacing(20)) {
            // Image and Brush area
            if let selectedImage = selectedImage {
                imageCanvasView(selectedImage: selectedImage)
            } else {
                Button(action: {
                    showUploadSheet = true
                }) {
                    UploadContainerView()
                }
            }
            
            if let selectedImage = selectedImage {
                // Use the reusable brush controls
                BrushControlsView(
                    currentTool: $currentTool,
                    brushSize: $brushSize,
                    onReset: { resetDrawing() }
                )
            }
   
        }
    }
    
    private func imageCanvasView(selectedImage: UIImage) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .topTrailing) {
    
                ZStack(alignment: .center) {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .background(
                            GeometryReader { imageGeometry -> Color in
                                let frame = imageGeometry.frame(in: .local)
                                DispatchQueue.main.async {
                                    self.imageFrame = frame
                                }
                                return Color.clear
                            }
                        )
                        .overlay(
                            ZStack {
                                // Red overlay for brushed areas
                                if !brushedAreas.isEmpty || needsRedraw {
                                    RedOverlayView(
                                        rects: $brushedAreas,
                                        imageSize: imageFrame.size,
                                        brushSize: brushSize
                                    )
                                    .allowsHitTesting(false)
                                }
                                
                                // Interactive brush area using reusable component
                                BrushAreaView(
                                    brushedAreas: $brushedAreas,
                                    currentTool: $currentTool,
                                    brushSize: $brushSize,
                                    containerSize: imageFrame.size,
                                    imageFrame: $imageFrame
                                )
                            }
                                .clipped()
                        )
                        .cornerRadius(15)
                       
                    
                    
                    if isIPad {
                        
                        Image(.imageBg)
                            .resizable()
                            .frame(width: ScaleUtility.scaledValue(647.01) ,
                                   height: ScaleUtility.scaledValue(346.99463))
                            .allowsHitTesting(false)
                        
                    }
                    else {
                        
                        Image(.imageBg)
                            .resizable()
                            .scaledToFit()
                            .allowsHitTesting(false)
                    }
                }
                
                
                Button{
                    clearSelectedImage()
                } label: {
                    Image(.crossIcon2)
                        .resizable()
                        .frame(width: ScaleUtility.scaledValue(18), height: ScaleUtility.scaledValue(18))
                        .padding(.all, ScaleUtility.scaledSpacing(5))
                        .background(Color.primaryApp.opacity(0.1))
                        .cornerRadius(30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.primaryApp.opacity(0.2), lineWidth: 1)
                        )
                }.offset(x: ScaleUtility.scaledSpacing(-15), y: ScaleUtility.scaledSpacing(15))
             
                 
            }
            .frame(width: geometry.size.width, height: min(geometry.size.height, ScaleUtility.scaledValue(345)))
        }
        .padding(.horizontal, ScaleUtility.scaledSpacing(15))
        .frame(height: ScaleUtility.scaledValue(345))
    }
    
    private func createMaskImage() -> UIImage? {
            guard let baseImage = selectedImage else { return nil }
            guard imageFrame.width > 0, imageFrame.height > 0 else { return nil }
            
            let originalSize = baseImage.size
            let scaleFactor = baseImage.scale
            
            let format = UIGraphicsImageRendererFormat()
            format.scale = 1.0
            let renderer = UIGraphicsImageRenderer(size: originalSize, format: format)
            
            let brushedImage = renderer.image { ctx in
                // Draw the original image first
                baseImage.draw(in: CGRect(origin: .zero, size: originalSize))
                
                // Draw brush marks on top
                let sx = originalSize.width / imageFrame.width
                let sy = originalSize.height / imageFrame.height
                
                for rect in brushedAreas {
                    let scaledRect = CGRect(
                        x: rect.origin.x * sx,
                        y: rect.origin.y * sy,
                        width: rect.size.width * sx,
                        height: rect.size.height * sy
                    )
                    
                    // Draw semi-transparent red circle to mark brushed areas
                    UIColor.red.withAlphaComponent(0.5).setFill()
                    let circlePath = UIBezierPath(ovalIn: scaledRect)
                    circlePath.fill()
                }
            }
            
            return UIImage(cgImage: brushedImage.cgImage!, scale: scaleFactor, orientation: baseImage.imageOrientation)
        }
        
        private func resetDrawing() {
            brushedAreas = []
            needsRedraw.toggle()
        }
        private func clearSelectedImage() {
            selectedImage = nil
            resetDrawing()
            resultImage = nil
            isGenerated = false
          
            
        }
        private func resetAndTryAgain() {
            isGenerated = false
            resultImage = nil
            loadingPercentage = 0
            showPromptBox = false
            resetDrawing()
        }
}
