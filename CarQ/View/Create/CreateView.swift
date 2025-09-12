//
//  CreateView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 09/09/25.
//

import Foundation
import SwiftUI

struct CreateView: View {
    @StateObject private var viewModel = GenerationViewModel()
    var onBack: () -> Void
    @State var prompt: String = ""
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
                        
                        PromptView(prompt: $prompt, isInputFocused: $searchFocused)
                        
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
                isProcessing = true
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
                    }
                }, onClose: {
                    onBack()
                }
            )
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
                    message: Text("Unable to Process Prompt."),
                    dismissButton: .default(Text("OK"))
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
                    showToast = false
                }
            )
        }
    }
}
