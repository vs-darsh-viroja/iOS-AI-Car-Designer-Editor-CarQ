//
//  ChangeColorView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 08/09/25.
//

import Foundation
import SwiftUI
import PhotosUI
// MARK: - Updated Change Color View
struct ChangeColorView: View {
    
    @StateObject private var ads = RewardedAdManager(adUnitID: "ca-app-pub-3940256099942544/5224354917")
    @StateObject var userDefault = UserSettings()
    @EnvironmentObject var purchaseManager: PurchaseManager
    @EnvironmentObject var remoteConfigManager: RemoteConfigManager
    
    var onBack: () -> Void
    
    @State var selectedColor: String = ""
    @State var customColorHex: String? = nil
    
    @State var selectedFinish: String = ""
    @State var selectedEffect: String = ""
    
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
    
    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
    
    @State var isShowPayWall: Bool = false
    @State var showPopUp: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                HeaderView(text: "Change Color", onBack: {
                    onBack()
                },onClose: {
                    
                },isCross: false)
                .padding(.top, ScaleUtility.scaledSpacing(15))
                
                ScrollView {
                    Spacer()
                        .frame(height: ScaleUtility.scaledValue(24))
                    
                    VStack(spacing: 0) {
                        mainBrushInterface()
                    }
                    
                    Spacer()
                        .frame(height: ScaleUtility.scaledValue(150))
                }
                
                Spacer()
            }
            GenerateButtonView(isDisabled: (!hasPresetColor && !hasCustomHex) || isProcessing,
                               action: {
                if brushedAreas.isEmpty {
                    activeAlert = .processingError(message: "Please brush areas you want to modify")
                } else if (customColorHex != nil) && selectedColor == "" {
                    activeAlert = .processingError(message: "Please select a color or enter a custom hex")
                } else {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        if !purchaseManager.hasPro && remoteConfigManager.showAds {
                            
                            if userDefault.freeImageGenerated < remoteConfigManager.freeConvertion {
                                
                                isProcessing = true
                                userDefault.freeImageGenerated += 1
                                
                            }
                            else if userDefault.freeImageGenerated == remoteConfigManager.freeConvertion && userDefault.rewardAdsImageGenerated >= remoteConfigManager.maximumRewardAd{
                                isShowPayWall = true
                            }
                            else {
                                showPopUp = true
                            }
                        }
                        else if !purchaseManager.hasPro && remoteConfigManager.temporaryAdsClosed {
                            if userDefault.rewardAdsImageGenerated >= remoteConfigManager.maximumRewardAd {
                                isShowPayWall = true
                            }
                            else {
                                
                                userDefault.rewardAdsImageGenerated += 1
                                isProcessing = true
                            }
                        }
                        else {
                            isProcessing = true
                        }
                    }
                }
            })
        }
        .navigationDestination(isPresented: $isProcessing) {
            ProcessingView(
                viewModel: viewModel,
                onBack: {
                    if viewModel.shouldReturn {
                        activeAlert = .processingError(message: viewModel.errorMessage ??  "Generation failed. Please try again.")
                        showPopUp = false
                        isProcessing = false
                        withAnimation { showToast = true }
                        viewModel.shouldReturn = false
                    } else {
                        isProcessing = false
                        showPopUp = false
                    }
                },
                onAppear: {
                    Task {
                        guard let original = selectedImage else {
                            viewModel.errorMessage = "No image selected."
                            viewModel.shouldReturn = true
                            return
                        }
                        
                        let finalPrompt = PromptBuilder.buildChangeColorPrompt(
                            colorKey: hasPresetColor ? selectedColor : "custom",
                            customColorHex: hasCustomHex ? customColorHex : nil,
                            finish: selectedFinish.isEmpty ? nil : selectedFinish,
                            effect: selectedEffect.isEmpty ? nil : selectedEffect
                        )
                        
                        viewModel.currentKind = .edited
                        viewModel.currentSource = "ChangeColorView"
                        viewModel.currentPrompt = finalPrompt
                        
                    
                        let started = await viewModel.startImageJob(image: original, prompt: finalPrompt)
                        if started {
                            await viewModel.pollUntilReady()
                        } else {
                            viewModel.shouldReturn = true
                        }
                        
                        AnalyticsHelper.logSelectionAnalytics(
                            color: selectedColor,
                            customColorHex: customColorHex,
                            finish: selectedFinish,
                            speicalEffect: selectedEffect
                        )
                        
                    }
                },
                onClose: { onBack() }
            )
            .background(Color.secondaryApp.edgesIgnoringSafeArea(.all))
        }
        .task {
            if !purchaseManager.hasPro {
                await ads.load()
            }
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
        .overlay {
            if showPopUp {
                ZStack {
                    Color.secondaryApp.opacity(0.6).ignoresSafeArea(.all)
                        .ignoresSafeArea(.all)
                        .transition(.opacity)
                        .onTapGesture {
                            // tap outside to close (optional)
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                showPopUp = false
                            }
                        }
                    
                    AdsAlertView {
                        isShowPayWall = true
                        AnalyticsManager.shared.log(.getPremiumFromAlert)
                        
                    } watchAds: {
                        AnalyticsManager.shared.log(.watchanAd)
                        ads.showOrProceed(
                            onReward: { _ in
                                AnalyticsManager.shared.log(.createScreen)
                                isProcessing = true
                                userDefault.rewardAdsImageGenerated += 1 },
                            proceedAnyway: {
                                AnalyticsManager.shared.log(.createScreen)
                                isProcessing = true
                                userDefault.rewardAdsImageGenerated += 1
                            }
                        )
                  
                    } closeAction: {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            showPopUp = false
                        }
                    }
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.95).combined(with: .opacity),
                        removal: .scale(scale: 0.85).combined(with: .opacity)
                    ))
                    .zIndex(1) // keep it above the dimmer
                   
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
        .fullScreenCover(isPresented: $isShowPayWall) {
            
            PaywallView(isInternalOpen: true) {
                showPopUp = false
                isShowPayWall = false
            } purchaseCompletSuccessfullyAction: {
                showPopUp = false
                isShowPayWall = false
            }
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
                    dismissButton: .default(Text("OK")) {
                        impactFeedback.impactOccurred()
                    }
                )
            case .processingError(let message):
                return Alert(
                    title: Text("Error"),
                    message: Text(message),
                    dismissButton: .default(Text("OK")) {
                        impactFeedback.impactOccurred()
                    }
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
            Button("Cancel", role: .cancel) {
                impactFeedback.impactOccurred()
            }
            Button("Open Settings") {
                impactFeedback.impactOccurred()
                if let url = URL(string: UIApplication.openSettingsURLString) { UIApplication.shared.open(url) }
            }
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
                    impactFeedback.impactOccurred()
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
   
            ColorListView(selectedColor: $selectedColor, customColorHex: $customColorHex)
            
            FinishView(selectedFinish: $selectedFinish)
            
            SpecialEffectView(selectedEffect: $selectedEffect)
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
                    impactFeedback.impactOccurred()
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
    
    private var hasPresetColor: Bool {
        !selectedColor.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private var hasCustomHex: Bool {
        if let hex = customColorHex?.trimmingCharacters(in: .whitespacesAndNewlines) {
            return !hex.isEmpty
        }
        return false
    }
}



