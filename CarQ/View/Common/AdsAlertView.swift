//
//  AdsAlertView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 19/09/25.
//

import Foundation
import SwiftUI


struct AdsAlertView: View {
    
    @State private var PayButtonPressed = false
    @State private var WatchAdsButtonPressed = false
    @State private var isCrossButtonPressed = false
    let impactfeedback = UIImpactFeedbackGenerator(style: .light)
    var needPremium: () -> Void
    var watchAds: () -> Void
    var closeAction: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Image(.adsBg1)
                    .resizable()
                    .frame(width: ScaleUtility.scaledValue(329), height: ScaleUtility.scaledValue(240))
                
                VStack {
                    VStack(spacing: ScaleUtility.scaledSpacing(18)) {
                        VStack(spacing: ScaleUtility.scaledSpacing(12)) {
                            HStack(spacing: ScaleUtility.scaledSpacing(26)) {
                                
                                Spacer()
                                
                                Text("Proceed to Generate")
                                    .font(FontManager.ChakraPetchMediumFont(size: .scaledFontSize(20)))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color.primaryApp)
                                
                                Button {
                                    impactfeedback.impactOccurred()
                                    closeAction()
                                } label: {
                                    Image(.crossIcon5)
                                        .resizable()
                                        .frame(width: ScaleUtility.scaledValue(16), height: ScaleUtility.scaledValue(16))
                                        .padding(.all, ScaleUtility.scaledSpacing(6))
                                        .background {
                                            Circle()
                                                .fill(Color.primaryApp.opacity(0.1))
                                        }
                                }

                            }
                            .padding(.horizontal, ScaleUtility.scaledSpacing(38))
                            
                            
                            Text("Watch an ad or get Pro plan\nto skip ads forever.")
                                .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(16)))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.primaryApp .opacity(0.5))
                            
                            
                        }
                        
                        VStack(spacing: ScaleUtility.scaledSpacing(10)) {
                            
                            Button {
                                impactfeedback.impactOccurred()
                                PayButtonPressed = true
                                WatchAdsButtonPressed = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    needPremium()
                                }
                            } label: {
                                Image(.adsBg2)
                                    .resizable()
                                    .frame(width: ScaleUtility.scaledValue(299), height: ScaleUtility.scaledValue(50))
                                    .overlay {
                                        HStack(spacing: ScaleUtility.scaledSpacing(9)) {
                                            Image(.crownIcon2)
                                                .resizable()
                                                .frame(width: ScaleUtility.scaledValue(24), height: ScaleUtility.scaledValue(24))
                                            
                                            Text("Get Premium")
                                                .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(16)))
                                                .multilineTextAlignment(.center)
                                                .foregroundColor(Color.primaryApp)
                                        }
                                        .padding(.vertical, ScaleUtility.scaledSpacing(13))
                                    }
                                    .overlay {
                                        if PayButtonPressed {
                                            Image(.adsOverlay1)
                                                .resizable()
                                                .frame(width: ScaleUtility.scaledValue(299), height: ScaleUtility.scaledValue(50))
                                        }
                                        else {
                                            Image(.adsOverlay2)
                                                .resizable()
                                                .frame(width: ScaleUtility.scaledValue(299), height: ScaleUtility.scaledValue(50))
                                        }
                                    }
                                
                            }

                            Button {
                                impactfeedback.impactOccurred()
                                WatchAdsButtonPressed = true
                                PayButtonPressed = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    watchAds()
                                }
                            } label: {
                              
                                Image(.adsBg2)
                                    .resizable()
                                    .frame(width: ScaleUtility.scaledValue(299), height: ScaleUtility.scaledValue(50))
                                    .overlay {
                                        HStack(spacing: ScaleUtility.scaledSpacing(9)) {
                                            Image(.playIcon)
                                                .resizable()
                                                .frame(width: ScaleUtility.scaledValue(23), height: ScaleUtility.scaledValue(23))
                                            
                                            Text("Watch an Ad")
                                                .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(16)))
                                                .multilineTextAlignment(.center)
                                                .foregroundColor(Color.primaryApp)
                                        }
                                        .padding(.vertical, ScaleUtility.scaledSpacing(13))
                                    }
                                    .overlay {
                                        Image(.adsOverlay2)
                                            .resizable()
                                            .frame(width: ScaleUtility.scaledValue(299), height: ScaleUtility.scaledValue(50))
                                    }
                                    .overlay {
                                        if WatchAdsButtonPressed {
                                            Image(.adsOverlay1)
                                                .resizable()
                                                .frame(width: ScaleUtility.scaledValue(299), height: ScaleUtility.scaledValue(50))
                                        }
                                        else {
                                            Image(.adsOverlay2)
                                                .resizable()
                                                .frame(width: ScaleUtility.scaledValue(299), height: ScaleUtility.scaledValue(50))
                                        }
                                    }
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
        }
    }
}

#Preview {
    ZStack {
        Color.secondaryApp.opacity(0.6).ignoresSafeArea(.all)
            .ignoresSafeArea(.all)
            .transition(.opacity)
        AdsAlertView(
            needPremium: { print("Premium tapped") },
            watchAds: { print("Watch ads tapped") },
            closeAction: { print("Close tapped") }
        )
    }
}
