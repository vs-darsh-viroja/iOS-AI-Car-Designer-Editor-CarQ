//
//  CreateView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 09/09/25.
//

import Foundation
import SwiftUI

struct CreateView: View {
    @StateObject private var ads = RewardedAdManager(adUnitID: "ca-app-pub-3940256099942544/5224354917")
    @StateObject var userDefault = UserSettings()
    @EnvironmentObject var purchaseManager: PurchaseManager
    @EnvironmentObject var remoteConfigManager: RemoteConfigManager
    
    @StateObject private var viewModel = GenerationViewModel()
    @Binding var prompt: String
    var onBack: () -> Void
    var onClose: () -> Void
    @FocusState private var searchFocused: Bool
    @State var selectedColor: String = ""
    @State var customColorHex: String? = nil // ADD THIS STATE
    @State var selectedCarType: String = ""
    @State var selectedDesignStyle: String = ""
    @State var selectedAccessory: String = ""
    @State var isProcessing: Bool = false
    
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var activeAlert: AlertType?
    
    let notificationFeedback = UINotificationFeedbackGenerator()
    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
    let selectionFeedback = UISelectionFeedbackGenerator()
    
    @State var isShowPayWall: Bool = false
    @State var showPopUp: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                
                HeaderView(text: "Create", onBack: {
                    onBack()
                },onClose: {
                    
                },isCross: false)
                .padding(.top, ScaleUtility.scaledSpacing(15))
                
                ScrollView {
                    
                    Spacer()
                        .frame(height: ScaleUtility.scaledValue(29))
                    
                    VStack(spacing: ScaleUtility.scaledSpacing(20)) {
                        
                        PromptView(screen: "Create", prompt: $prompt, isInputFocused: $searchFocused)
                        
                        ColorListView(selectedColor: $selectedColor, customColorHex: $customColorHex) // PASS THE BINDING
                        
                        CarTypesView(selectedCarType: $selectedCarType)
                        
                        DesignStylesView(selectedDesignStyle: $selectedDesignStyle)
                        
                        AccessoriesView(selectedAccessory: $selectedAccessory)
                    }
                    
                    Spacer()
                        .frame(height: ScaleUtility.scaledValue(150))
                    
                }
             
            }
            
            Spacer()
            
            GenerateButtonView(isDisabled: prompt == "" ? true : false, action: {
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
            })
            
            
        }
        .navigationBarHidden(true)
        .ignoresSafeArea(.container, edges: [.bottom])
        .toolbar(.hidden, for: .navigationBar)
        .ignoresSafeArea(.keyboard)
        .navigationBarHidden(true)
        .background(Color.secondaryApp.edgesIgnoringSafeArea(.all))
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
                    }
                    else {
                        showPopUp = false
                        isProcessing = false

                    }
                   
                },
                onAppear: {
                    Task {
                        let finalPrompt = PromptBuilder.buildTextPrompt(
                            description: prompt,                             // REQUIRED
                            color: selectedColor.isEmpty ? nil : selectedColor, // Pass selected color key
                            customColorHex: customColorHex,                  // Pass custom color hex if available
                            carType: selectedCarType.isEmpty ? nil : selectedCarType,
                            designStyle: selectedDesignStyle.isEmpty ? nil : selectedDesignStyle,
                            accessory: selectedAccessory.isEmpty ? nil : selectedAccessory
                        )
         
                        
                        viewModel.currentKind = .generated
                        viewModel.currentSource = "CreateView"
                        viewModel.currentPrompt = prompt
                        

                        let started = await viewModel.startTextJob(prompt: finalPrompt)
                        if started {
                            await viewModel.pollUntilReady()
                        } else {
                            viewModel.shouldReturn = true
                        }
                        
                        AnalyticsHelper.logSelectionAnalytics(
                            designStyle: selectedDesignStyle,
                            carType: selectedCarType,
                            accessory: selectedAccessory,
                            color: selectedColor,
                            customColorHex: customColorHex
                        )
                    }
                }, onClose: {
                    onBack()
                    onClose()
                }
            )
            .background(Color.secondaryApp.edgesIgnoringSafeArea(.all))
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
                    message: Text("Unable to Process Prompt."),
                    dismissButton: .default(Text("OK")) {
                        impactFeedback.impactOccurred()
                    }
                )
            }
        }
        .alert(isPresented: $showToast) {
            Alert(
                title: Text("Error"),
                message: Text("Unable to Process Prompt.")
                    .foregroundColor(Color.red)
                ,
                dismissButton: .default(Text("OK")) {
                    impactFeedback.impactOccurred()
                    showToast = false
                 
                }
            )
        }
        .task {
            if !purchaseManager.hasPro {
                await ads.load()
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
        .fullScreenCover(isPresented: $isShowPayWall) {
            
            PaywallView(isInternalOpen: true) {
                showPopUp = false
                isShowPayWall = false
            } purchaseCompletSuccessfullyAction: {
                showPopUp = false
                isShowPayWall = false
            }
        }
    }
}
