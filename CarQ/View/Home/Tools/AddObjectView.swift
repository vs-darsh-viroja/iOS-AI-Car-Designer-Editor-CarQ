//
//  AddObjectView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 08/09/25.
//

import Foundation
import SwiftUI

struct AddObjectView: View {
    @StateObject private var keyboard = KeyboardResponder()
    var onBack: () -> Void
    @State var prompt: String = ""
    @FocusState private var searchFocused: Bool
    
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
                            .frame(height: ScaleUtility.scaledValue(29))
                        
                        VStack(spacing: ScaleUtility.scaledSpacing(20)) {
                            
                            UploadContainerView()
                            
                            UploadReferenceImageView(isOptional: false)
                            
                            PromptView(prompt: $prompt, isInputFocused: $searchFocused)
                        }
                       
                        if keyboard.currentHeight > 0 {
                            
                            Spacer()
                                .frame(height: ScaleUtility.scaledValue(250))
                            
                        }
                        else {
                            Spacer()
                                .frame(height: ScaleUtility.scaledValue(80))
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
            
            GenerateButtonView(isDisabled: true, action: {
                
            })
        }
        .ignoresSafeArea(.container, edges: [.bottom])
        .toolbar(.hidden, for: .navigationBar)
        .ignoresSafeArea(.keyboard)
        .navigationBarHidden(true)
        .background(Color.secondaryApp.edgesIgnoringSafeArea(.all))
        
    }
}
