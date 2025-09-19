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
    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                HeaderView(text: "Recreate",
                           onBack: {
                    onBack()
                },
                           onClose: {
                    
                },
                           isCross: false)
                .padding(.top, ScaleUtility.scaledSpacing(9))
                
                ScrollView {
                   
                    Spacer()
                        .frame(height: ScaleUtility.scaledValue(25))
                    
                    VStack(spacing: ScaleUtility.scaledSpacing(20)) {
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
                                        .frame(width: 792 * ipadWidthRatio ,
                                               height: 913.99463 * ipadHeightRatio)
                                    
                                    
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
                        .frame(height: isIPad ? ScaleUtility.scaledValue(150) :  ScaleUtility.scaledValue(100))
                    
                }
                
            }
            
            Spacer()
            
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
                    .frame(maxWidth: .infinity)
                    .frame(height: isIPad ? ScaleUtility.scaledValue(157) : ScaleUtility.scaledValue(117))
                    .allowsHitTesting(true)
                
                
                Image(.bgBlur)
                    .resizable()
                    .frame(maxWidth: .infinity)
                    .frame(height: isIPad ? ScaleUtility.scaledValue(157) : ScaleUtility.scaledValue(117))
                    .allowsHitTesting(true)
                    .ignoresSafeArea(.all)
                
                Button {
                    AnalyticsManager.shared.log(.recreate)
                    impactFeedback.impactOccurred()
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
          
        }
        .ignoresSafeArea(.container, edges: [.bottom])
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
