//
//  MagicalModificationView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 08/09/25.
//

import Foundation
import SwiftUI
import PhotosUI

struct MagicalModificationView: View {
    @State var selectedType: String = ""
    @StateObject private var keyboard = KeyboardResponder()
    var onBack: () -> Void
    @State var prompt: String = ""
    @FocusState private var searchFocused: Bool
    
    @State private var showUploadSheet = false
    
    @State private var selectedCarItem: PhotosPickerItem? = nil
    @State private var selectedCarUIImage: UIImage? = nil
    @State private var selectedCarImage: Image? = nil
    @State private var originalCarUIImage: UIImage? = nil // Keep original for reset
    
    @State private var showCameraPickerVenue = false
    @State private var showPhotoPickerVenue = false
    
    @State private var showCameraPermissionAlert = false
    @State private var cameraDeniedOnce = false
    
    @State private var showToast = false
    @State private var toastMessage = ""
    @State var selectedEraser: String = "Brush"

    @State private var drawingCanvasView: DrawingCanvasView? = nil
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            VStack(spacing: 0) {
                
                HeaderView(text: "Magical Modification", onBack: {
                    onBack()
                })
                .padding(.top, ScaleUtility.scaledSpacing(15))
                
                ScrollViewReader { scrollView in
                    
                    ScrollView {
                        
                        Spacer()
                            .frame(height: ScaleUtility.scaledValue(29))
                        
                        VStack(spacing: ScaleUtility.scaledSpacing(20)) {
                            
                            if let image = selectedCarImage {
                                ImageCard(
                                    selectedEraser: $selectedEraser,
                                    image: image,
                                    uiImage: selectedCarUIImage,
                                    onRemove: {
                                        selectedCarImage = nil
                                        selectedCarUIImage = nil
                                        originalCarUIImage = nil
                                        drawingCanvasView = nil
                                    },
                                    onReset: {
                                        // Reset to original image
                                        if let original = originalCarUIImage {
                                            selectedCarUIImage = original
                                            selectedCarImage = Image(uiImage: original)
                                        }
                                        // Clear any drawings
                                        drawingCanvasView?.clearDrawing()
                                    }
                                )
                            }
                            else {
                                Button(action: {
                                    showUploadSheet = true
                                }) {
                                    UploadContainerView()
                                }
                            }
                            
                            
                            VStack(spacing: ScaleUtility.scaledSpacing(13)) {
                                Text("Change Type")
                                    .font(FontManager.ChakraPetchSemiBoldFont(size: .scaledFontSize(18)))
                                    .foregroundColor(Color.primaryApp)
                                    .padding(.leading, ScaleUtility.scaledSpacing(15))
                                    .frame(maxWidth: .infinity,alignment: .leading)
                                
                                HStack(spacing: isIPad ? ScaleUtility.scaledSpacing(16) : ScaleUtility.scaledSpacing(6)) {
                                    
                                    Button {
                                        selectedType = "Resize"
                                    } label: {
                                        Image(.selectionBg1)
                                            .resizable()
                                            .frame(width: isIPad ? ScaleUtility.scaledValue(231) : ScaleUtility.scaledValue(111),
                                                   height: isIPad ? ScaleUtility.scaledValue(60) : ScaleUtility.scaledValue(40))
                                            .overlay {
                                                Text("Resize")
                                                    .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(16)))
                                                    .foregroundColor(Color.primaryApp.opacity(0.4))
                                            }
                                            .overlay {
                                                if selectedType == "Resize" {
                                                    Image(.selectionOverlay1)
                                                        .resizable()
                                                        .frame(width: isIPad ? ScaleUtility.scaledValue(231) : ScaleUtility.scaledValue(111),
                                                               height: isIPad ? ScaleUtility.scaledValue(60) : ScaleUtility.scaledValue(40))
                                                }
                                            }
                                    }
                                    
                                    Button {
                                        selectedType = "Reshape"
                                    } label: {
                                        Image(.selectionBg1)
                                            .resizable()
                                            .frame(width: isIPad ? ScaleUtility.scaledValue(231) : ScaleUtility.scaledValue(111),
                                                   height: isIPad ? ScaleUtility.scaledValue(60) : ScaleUtility.scaledValue(40))
                                            .overlay {
                                                Text("Reshape")
                                                    .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(16)))
                                                    .foregroundColor(Color.primaryApp.opacity(0.4))
                                                
                                            }
                                            .overlay {
                                                if selectedType == "Reshape" {
                                                    Image(.selectionOverlay1)
                                                        .resizable()
                                                        .frame(width: isIPad ? ScaleUtility.scaledValue(231) : ScaleUtility.scaledValue(111),
                                                               height: isIPad ? ScaleUtility.scaledValue(60) : ScaleUtility.scaledValue(40))
                                                }
                                            }
                                    }
                                    
                                    Button {
                                        selectedType = "Redesign"
                                    } label: {
                                        Image(.selectionBg1)
                                            .resizable()
                                            .frame(width: isIPad ? ScaleUtility.scaledValue(231) : ScaleUtility.scaledValue(111),
                                                   height: isIPad ? ScaleUtility.scaledValue(60) : ScaleUtility.scaledValue(40))
                                            .overlay {
                                                Text("Redesign")
                                                    .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(16)))
                                                    .foregroundColor(Color.primaryApp.opacity(0.4))
                                            }
                                            .overlay {
                                                if selectedType == "Redesign" {
                                                    Image(.selectionOverlay1)
                                                        .resizable()
                                                        .frame(width: isIPad ? ScaleUtility.scaledValue(231) : ScaleUtility.scaledValue(111),
                                                               height: isIPad ? ScaleUtility.scaledValue(60) : ScaleUtility.scaledValue(40))
                                                }
                                            }
                                    }
                                    
                                    
                                }
                            }
                            
                            PromptView(prompt: $prompt, isInputFocused: $searchFocused)
                            
                            
                            
                        }
                        
                        if keyboard.currentHeight > 0 {
                            
                            Spacer()
                                .frame(height: ScaleUtility.scaledValue(330))
                            
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
                
                Spacer()
                
            }
            .frame(maxWidth: .infinity,maxHeight: .infinity)
            
            
            GenerateButtonView(isDisabled: true, action: {
                
            })
            
            
            
        }
        .alert(isPresented: $showToast) {
            Alert(
                title: Text("Error"),
                message: Text(toastMessage),
                dismissButton: .default(Text("OK")) {
                    showToast = false
                }
            )
        }
        // VENUE
        .onChange(of: selectedCarItem) { _, newItem in
            guard let newItem else { return }
            Task {
                if let data = try? await newItem.loadTransferable(type: Data.self),
                   let ui = UIImage(data: data) {
                    selectedCarUIImage = ui
                    selectedCarImage = Image(uiImage: ui)
                }
            }
        }
        .alert("Camera Access Needed", isPresented: $showCameraPermissionAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Open Settings") { if let url = URL(string: UIApplication.openSettingsURLString) { UIApplication.shared.open(url) } }
        } message: {
            Text("Please enable Camera access in Settings to take a photo.")
        }
        .sheet(isPresented: $showUploadSheet) {
            UploadImageSheetView(showSheet: $showUploadSheet,
                                 onCameraTap: {
                showUploadSheet = false
                Task { @MainActor in
                    if await CameraAuth.requestIfNeeded() {
                        try? await Task.sleep(nanoseconds: 300_000_000)
                        showCameraPickerVenue = true
                        
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
                    showPhotoPickerVenue = true
                    
                }
            })
            .presentationDetents([.height( isIPad ? 410 : 210)])
            .presentationCornerRadius(25)
            .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showCameraPickerVenue) {
            CameraPicker(image: $selectedCarImage, uiImage: $selectedCarUIImage)
        }
        .photosPicker(isPresented: $showPhotoPickerVenue, selection: $selectedCarItem, matching: .images)
        .ignoresSafeArea(.container, edges: [.bottom])
        .toolbar(.hidden, for: .navigationBar)
        .ignoresSafeArea(.keyboard)
        .navigationBarHidden(true)
        .background(Color.secondaryApp.edgesIgnoringSafeArea(.all))
       
    }
}
