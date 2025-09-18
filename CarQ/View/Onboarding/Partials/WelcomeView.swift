//
//  WelcomeView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 18/09/25.
//



import Foundation
import SwiftUI

struct WelcomeView: View {
    // Animation state - Start COMPLETELY off screen
    @State private var leftHexagonOffset: CGFloat = -400
    @State private var rightHexagonOffset: CGFloat = 400
    @State private var textOpacity: Double = 0
    
    // Track current screen from SwipeView
    @AppStorage("currentOnboardingIndex") private var currentScreenIndex: Int = 0
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                HStack(spacing: 0) {
                    
                    Image(.hezagonalIcon1)
                        .resizable()
                        .frame(width: isIPad ? ScaleUtility.scaledValue(68) : ScaleUtility.scaledValue(48),
                               height: isIPad ? ScaleUtility.scaledValue(216) :  ScaleUtility.scaledValue(196))
                        .offset(x: leftHexagonOffset)
                    
                    Spacer()
                    
                    Image(.hezagonalIcon2)
                        .resizable()
                        .frame(width: isIPad ? ScaleUtility.scaledValue(68) : ScaleUtility.scaledValue(48),
                               height: isIPad ? ScaleUtility.scaledValue(216) :  ScaleUtility.scaledValue(196))
                        .offset(x: rightHexagonOffset)
                }
                .padding(.top, ScaleUtility.scaledSpacing(48))
                
                VStack(spacing: ScaleUtility.scaledSpacing(25)) {
                    VStack(spacing: 0) {
                        Text("CarQ")
                            .font(FontManager.ChakraPetchBoldFont(size: .scaledFontSize(60)))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.primaryApp)
                        
                        Text("AI Car Designer & Editor")
                            .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(24)))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.primaryApp)
                    }
                    
                    Text("Design & Modify\nany vehicle the way you want.")
                        .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(18)))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.primaryApp.opacity(0.75))
                }
                .padding(.top, ScaleUtility.scaledSpacing(97))
                .opacity(textOpacity)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.container, edges: [.bottom])
        .toolbar(.hidden, for: .navigationBar)
        .background {
            Image(.onboarding1)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea(.all)
        }
        .ignoresSafeArea(.all)
        .onAppear {
            print("WelcomeView appeared, currentScreenIndex: \(currentScreenIndex)")
            // Immediately reset to off-screen position
            resetToOffScreen()
            
            // Always animate welcome screen on appear (after delay for proper rendering)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                startAnimation()
            }
        }
        .onChange(of: currentScreenIndex) { oldIndex, newIndex in
            print("Welcome screen: changed from \(oldIndex) to \(newIndex)")
            
            if newIndex == 0 {
                // Reset immediately when welcome screen becomes active
                resetToOffScreen()
                // Start animation after a short delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    startAnimation()
                }
            } else {
                // Hide elements when screen is not active
                resetToOffScreen()
            }
        }
    }
    
    private func resetToOffScreen() {
        // Make sure hexagons are completely off screen
        withAnimation(.linear(duration: 0.0)) {
            leftHexagonOffset = -400
            rightHexagonOffset = 400
            textOpacity = 0
        }
    }
    
    private func startAnimation() {
        print("Starting animation for Welcome screen")
        
        // Animate hexagons sliding in with easeOut for smooth deceleration without overshoot
        withAnimation(.easeOut(duration: 0.8)) {
            leftHexagonOffset = 0
            rightHexagonOffset = 0
        }
        
        // Animate text fading in with delay
        withAnimation(.easeIn(duration: 0.6).delay(0.3)) {
            textOpacity = 1
        }
    }
}
