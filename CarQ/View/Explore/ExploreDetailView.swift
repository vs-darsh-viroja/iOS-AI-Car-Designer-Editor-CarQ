//
//  ExploreDetailView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 17/09/25.
//

import Foundation
import SwiftUI


struct ExploreDetailView: View {
    let card: ExploreCard
    var onBack: () -> Void

    
    @State private var promptText: String
    @State private var isCreateScreen = false
    
     init(card: ExploreCard, onBack: @escaping () -> Void) {
         self.card = card
         self.onBack = onBack
         self._promptText = State(initialValue: card.prompt.isEmpty ? "No prompt available" : card.prompt)
     }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: ScaleUtility.scaledSpacing(25)) {
                HeaderView(text: "Recreate",
                           onBack: {
                    onBack()
                },
                           onClose: {
                    
                },
                           isCross: false)
                .padding(.top, ScaleUtility.scaledSpacing(9))
                
                // Large image display
                Image(card.imageName)
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, ScaleUtility.scaledSpacing(15))
                    .frame(minHeight: isIPad
                           ? ScaleUtility.scaledValue(480.99463)
                           : ScaleUtility.scaledValue(345))
                    .overlay {
                        
                        if isIPad {
                            
                            Image(.imageBg)
                                .resizable()
                                .frame(width: 702 * ipadWidthRatio ,
                                       height: 813.99463 * ipadHeightRatio)
                            
                            
                        }
                        else {
                            
                            Image(.imageBg)
                                .resizable()
                                .scaledToFit()
                            
                        }
                    }
                
                ExplorePromptView(text: $promptText)
                
                
                
            }
            
            Spacer()
            
            Button {
                isCreateScreen = true
            } label: {
                
                Text("Recreate")
                    .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(18)))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.primaryApp)
                    .frame(maxWidth: .infinity)
            }
            .background {
                Image(.buttonBg3)
                    .resizable()
                    .frame(width: isIPad ? ScaleUtility.scaledValue(715) : ScaleUtility.scaledValue(345),
                           height: ScaleUtility.scaledValue(60))
                    .overlay {
                        
                        Image(.selectButtonBg)
                            .resizable()
                            .frame(width: isIPad ? ScaleUtility.scaledValue(715) : ScaleUtility.scaledValue(345),
                                   height: ScaleUtility.scaledValue(60))
                        
                    }
            }
            .padding(.bottom, ScaleUtility.scaledSpacing(25))
        }
        .background(Color.secondaryApp.edgesIgnoringSafeArea(.all))
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $isCreateScreen) {
            CreateView(prompt: $promptText,onBack: {
              isCreateScreen = false
            },onClose: {
                onBack()
            })
            .background(Color.secondaryApp.ignoresSafeArea(.all))
        }
    }
}
