//
//  ModifyObjectView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 08/09/25.
//

import Foundation
import SwiftUI
import PhotosUI


struct AddObjectView: View {
    var onBack: () -> Void
    @StateObject private var keyboard = KeyboardResponder()
    @State var prompt: String = ""
    @FocusState private var searchFocused: Bool
    @State private var activeUploadType: UploadType? = nil
    
    // Image selection states
    @State private var showUploadSheet = false
    @State private var targetPhotoItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage?
    @State private var showCameraPicker = false
    @State private var showPhotoPicker = false
    
    // Reference Image selection states
    @State private var referencePhotoItem: PhotosPickerItem? = nil
    @State private var referenceImage: UIImage?
    @State private var showReferenceCameraPicker = false
    @State private var showReferencePhotoPicker = false
    @State private var showFullReferenceImage: Bool = false
    
    
    @State private var showCameraPermissionAlert = false
    @State private var cameraDeniedOnce = false
    
    @State private var showToast = false
    @State private var toastMessage = ""

    @State private var resultImage: UIImage?
    
    @State private var isGenerated = false
    @State private var loadingPercentage = 0
    @State private var showPromptBox = false
   
    // Brush states - using the shared enum now
    @State private var brushedAreas = [CGRect]()
    @State private var currentTool: DrawingTool = .brush // Using shared enum
    @State private var brushSize: CGFloat = 20
    @State private var imageFrame: CGRect = .zero
    @State private var referenceImageFrame: CGRect = .zero
    @State private var needsRedraw = false
    
    @State private var activeAlert: AlertType?
    @State var isProcessing: Bool = false
    @StateObject private var viewModel = GenerationViewModel()
  
    @Namespace private var refImageNS
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                HeaderView(text: "Add Object", onBack: {
                    onBack()
                },onClose: {
                    
                },isCross: false)
                .padding(.top, ScaleUtility.scaledSpacing(15))
                
                ScrollViewReader { scrollView in
                    ScrollView {
                        
                        Spacer()
                            .frame(height: ScaleUtility.scaledValue(24))
                        
                        VStack(spacing: 0) {
                            
                            mainBrushInterface()
           
                        }
                       
                        if keyboard.currentHeight > 0 {
                            
                            Spacer()
                                .frame(height: ScaleUtility.scaledValue(350))
                            
                        }
                        else {
                            Spacer()
                                .frame(height: ScaleUtility.scaledValue(150))
                        }
                        
                        Color.clear
                            .frame(maxWidth: .infinity)
                            .frame(height: ScaleUtility.scaledValue(1))
                            .id("ScrollToBottom")
                        
                        
                    }
                    .onChange(of: keyboard.currentHeight) { height in
                        // Scroll when keyboard appears/disappears
                        if height > 0 {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                withAnimation(.easeOut(duration: 0.25)) {
                                    scrollView.scrollTo("ScrollToBottom", anchor: .bottom)
                                }
                            }
                        }
                    }
                }
            }
            
            Spacer()
            
            GenerateButtonView(isDisabled: false, action: {
                if brushedAreas.isEmpty {
                    activeAlert = .processingError(message: "Please brush the areas where you want to add an object")
                } else if prompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    activeAlert = .processingError(message: "Please enter a prompt to describe the desired changes")
                } else {
                    isProcessing = true
                }
            })
            
        }
        .ignoresSafeArea(.container, edges: [.bottom])
        .toolbar(.hidden, for: .navigationBar)
        .ignoresSafeArea(.keyboard)
        .navigationBarHidden(true)
        .background(Color.secondaryApp.edgesIgnoringSafeArea(.all))
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
        // REFERENCE
        .onChange(of: referencePhotoItem) { _, newItem in
            guard let newItem else { return }
            Task {
                if let data = try? await newItem.loadTransferable(type: Data.self),
                   let ui = UIImage(data: data) {
                    referenceImage = ui
                    
                }
            }
        }
        .navigationDestination(isPresented: $isProcessing) {
            ProcessingView(
                viewModel: viewModel,
                onBack: {
                    if viewModel.shouldReturn {
                        activeAlert = .processingError(message: viewModel.errorMessage ?? "Generation failed. Please try again.")
                        isProcessing = false
                        withAnimation { showToast = true }
                        viewModel.shouldReturn = false
                    } else {
                        isProcessing = false
                    }
                },
                onAppear: {
                    Task {
                        guard let originalImage = selectedImage,
                              let maskImage = createMaskImage() // referenceImage is OPTIONAL
                        else {
                            viewModel.errorMessage = "Failed to create mask image"
                            viewModel.shouldReturn = true
                            return
                        }

                        viewModel.currentKind = .edited
                        viewModel.currentSource = "AddObjectView"
                        viewModel.currentPrompt = prompt

                        // Build prompt (requires you to add this helper)
                        let finalPrompt = PromptBuilder.buildAddObjectPrompt(
                            userPrompt: prompt,
                            hasReference: (referenceImage != nil)
                        )


                        // Kick off job (requires you to add this VM method + NetworkManager API)
                        let started = await viewModel.startMultiImageJob(
                            image: originalImage,
                            maskImage: maskImage,
                            referenceImage: referenceImage, // can be nil
                            prompt: finalPrompt
                        )

                        if started {
                            await viewModel.pollUntilReady()
                        } else {
                            viewModel.shouldReturn = true
                        }
                    }
                },
                onClose: { onBack() }
            )

            }
        .sheet(isPresented: $showUploadSheet) {
            UploadImageSheetView(showSheet: $showUploadSheet,
                                 onCameraTap: {
                showUploadSheet = false
                Task { @MainActor in
                    if await CameraAuth.requestIfNeeded() {
                        try? await Task.sleep(nanoseconds: 300_000_000)
                        if activeUploadType == .primary { showCameraPicker = true }
                        else if activeUploadType == .reference { showReferenceCameraPicker = true }
                        
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
                    if activeUploadType == .primary { showPhotoPicker = true }
                    else if activeUploadType == .reference { showReferencePhotoPicker = true }
                    
                    
                }
            })
            .presentationDetents([.height( isIPad ? 410 : 210)])
            .presentationCornerRadius(25)
            .presentationDragIndicator(.visible)
        }
        .fullScreenCover(isPresented: $showCameraPicker) {
            ImagePicker(sourceType: .camera) { image in
                selectedImage = image
                resetDrawing()
            }
        }
        .fullScreenCover(isPresented: $showReferenceCameraPicker) {
            ImagePicker(sourceType: .camera) { image in
                referenceImage = image
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
        .photosPicker(isPresented: $showReferencePhotoPicker, selection: $referencePhotoItem, matching: .images)
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
                    activeUploadType = .primary
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
         
            if let referenceImage = referenceImage {
                referenceImageCanvasView(selectedImage: referenceImage)
            }
            else {
                Button(action: {
                    showUploadSheet = true
                    activeUploadType = .reference
                }) {
                   UploadReferenceImageView(isOptional: true)
                }
            }
            
            
            PromptView(prompt: $prompt, isInputFocused: $searchFocused)
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
    
    private func referenceImageCanvasView(selectedImage: UIImage) -> some View {
        GeometryReader { geometry in
        if showFullReferenceImage {
                ZStack(alignment: .topTrailing) {
                    
                    ZStack(alignment: .center) {
                        
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .matchedGeometryEffect(id: "refImage", in: refImageNS)
                            .background(
                                GeometryReader { imageGeometry -> Color in
                                    let frame = imageGeometry.frame(in: .local)
                                    DispatchQueue.main.async {
                                        self.referenceImageFrame = frame
                                    }
                                    return Color.clear
                                }
                            )
                            .cornerRadius(15)
                        
                        Image(.referenceBg2)
                            .resizable()
                            .frame(maxWidth: .infinity)
                            .frame(height: 170)
                    }
             
                    
                    
                    Button{
                        clearReferenceImage()
                        showFullReferenceImage = false
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
                .frame(width: geometry.size.width, height: min(geometry.size.height, ScaleUtility.scaledValue(160)))
                .transition(.opacity)
        }
            else {
                
                HStack {
                    HStack(spacing: 15) {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 45, height: 45)
                            .background(
                                Image(uiImage: selectedImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 45, height: 45)
                                    .clipped()
                                    .matchedGeometryEffect(id: "refImage", in: refImageNS)
                            )
                            .cornerRadius(45)
                        
                        Text("Reference Image")
                            .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(14)))
                            .foregroundColor(Color.primaryApp)
                        
                    }
                    Spacer()
                    
                    Button {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.85, blendDuration: 0.2)) {
                               showFullReferenceImage = true
                           }
                    } label: {
                        Image(.downIcon)
                            .resizable()
                            .frame(width: ScaleUtility.scaledValue(24), height: ScaleUtility.scaledValue(24))
                    }
                    
                    
                }
                .padding(.horizontal,15)
                .padding(.vertical,7)
                .background {
                    Image(.referenceBg1)
                        .resizable()
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                }
                
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: showFullReferenceImage)
        .padding(.horizontal, ScaleUtility.scaledSpacing(15))
        .frame(height: showFullReferenceImage ? ScaleUtility.scaledValue(160) : ScaleUtility.scaledValue(60))
        
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
    private func clearReferenceImage() {
        referenceImage = nil
        isGenerated = false
        
    }
        private func resetAndTryAgain() {
            isGenerated = false
            resultImage = nil
            loadingPercentage = 0
            showPromptBox = false
            prompt = ""
            resetDrawing()
        }
    
}
