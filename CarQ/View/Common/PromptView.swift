//
//  PromptView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 08/09/25.
//

import Foundation
import SwiftUI

struct PromptView: View {
    
    @Binding var prompt: String
    @FocusState.Binding var isInputFocused: Bool
    
    var body: some View {
       
            Image(.promptField)
                .resizable()
                .frame(width: ScaleUtility.scaledValue(345), height: ScaleUtility.scaledValue(160))
                .overlay {
                    VStack {
                        
                        ZStack(alignment: .topLeading) {
                            if prompt.isEmpty {
                                Text("Enter your prompt...")
                                    .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(14)))
                                    .foregroundColor(Color.primaryApp.opacity(0.25))
                             
                            }
                            
                            CustomTextEditor(text: $prompt)
                                .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(14)))
                                .focused($isInputFocused)
                                .scrollContentBackground(.hidden)
                                .background(.clear)
                                .foregroundColor(Color.primaryApp)
                                .offset(x: ScaleUtility.scaledSpacing(-3), y: ScaleUtility.scaledSpacing(-7))
                            
                        }
                        
                        Spacer()
                        
                        HStack {
                            
                            Button {
                                prompt = ""
                            } label: {
                                Text("Clear")
                                    .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(14)))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color.primaryApp.opacity(0.5))
                            }

                            Spacer()
                               
                            HStack(spacing: ScaleUtility.scaledSpacing(5)) {
                                
                                Image(.lampIcon)
                                    .resizable()
                                    .frame(width: ScaleUtility.scaledValue(18), height: ScaleUtility.scaledValue(18))
                                
                                Text("Get Idea")
                                    .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(14)))
                              
                                
                            }
                            .foregroundColor(Color.primaryApp)
                            .opacity(0.5)
                            
                        }
                       
                        
                    }
                    .padding(.horizontal, ScaleUtility.scaledSpacing(15))
                    .padding(.vertical, ScaleUtility.scaledSpacing(15))
                }
        
    }
}
