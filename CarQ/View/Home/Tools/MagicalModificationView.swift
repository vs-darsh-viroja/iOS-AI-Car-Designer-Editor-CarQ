//
//  MagicalModificationView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 08/09/25.
//

import Foundation
import SwiftUI

struct MagicalModificationView: View {
    @State var selectedType: String = ""
    @StateObject private var keyboard = KeyboardResponder()
    var onBack: () -> Void
    @State var prompt: String = ""
    @FocusState private var searchFocused: Bool
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
                            
                            UploadContainerView()
                            
                            
                            
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
        .ignoresSafeArea(.container, edges: [.bottom])
        .toolbar(.hidden, for: .navigationBar)
        .ignoresSafeArea(.keyboard)
        .navigationBarHidden(true)
        .background(Color.secondaryApp.edgesIgnoringSafeArea(.all))
       
    }
}
