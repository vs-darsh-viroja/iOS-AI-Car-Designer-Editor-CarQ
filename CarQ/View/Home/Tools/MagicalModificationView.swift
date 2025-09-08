//
//  MagicalModificationView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 08/09/25.
//

import Foundation
import SwiftUI

struct MagicalModificationView: View {
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
                        
                        HStack {
                            
                            Button {
                                
                            } label: {
                                Image(.uploadBg2)
                                    .resizable()
                                    .frame(width: ScaleUtility.scaledValue(111), height: ScaleUtility.scaledValue(40))
                                    .overlay {
                                        Text("Resize")
                                            .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(16)))
                                            .foregroundColor(Color.primaryApp.opacity(0.4))
                                    }
                            }
                            
                            Button {
                                
                            } label: {
                                Image(.uploadBg2)
                                    .resizable()
                                    .frame(width: ScaleUtility.scaledValue(111), height: ScaleUtility.scaledValue(40))
                                    .overlay {
                                        Text("Reshape")
                                            .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(16)))
                                            .foregroundColor(Color.primaryApp.opacity(0.4))
                                    }
                            }
                            
                            Button {
                                
                            } label: {
                                Image(.uploadBg2)
                                    .resizable()
                                    .frame(width: ScaleUtility.scaledValue(111), height: ScaleUtility.scaledValue(40))
                                    .overlay {
                                        Text("Redesign")
                                            .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(16)))
                                            .foregroundColor(Color.primaryApp.opacity(0.4))
                                    }
                            }
                            
                            
                        }
                    }
                    
                    PromptView(prompt: $prompt, isInputFocused: $searchFocused)
           
                     
                    
                }
                
                Spacer()
                    .frame(height: ScaleUtility.scaledValue(200))
                
            }
            
        }
            
            Spacer()
            
        }
            
            ZStack {
                
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.black.opacity(0.8),
                                Color.black.opacity(0.4),
                                Color.black.opacity(0.0)
                            ]),
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                    .frame(height: 100)
                    .allowsHitTesting(true)
                    .ignoresSafeArea(.all)
                
                Button {
                    
                } label: {
                    
                    Text("Generate")
                        .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(18)))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.primaryApp.opacity(0.25))
                        .frame(maxWidth: .infinity)
                }
                .background {
                    Image(.buttonBg2)
                        .resizable()
                        .frame(width: ScaleUtility.scaledValue(345), height: ScaleUtility.scaledValue(60))
                }
                .padding(.bottom, ScaleUtility.scaledSpacing(26))
                
            }
      
            
        }
       .ignoresSafeArea(.container, edges: [.bottom])
       .toolbar(.hidden, for: .navigationBar)
        .ignoresSafeArea(.keyboard)
        .navigationBarHidden(true)
        .background(Color.secondaryApp.edgesIgnoringSafeArea(.all))
       
    }
}
