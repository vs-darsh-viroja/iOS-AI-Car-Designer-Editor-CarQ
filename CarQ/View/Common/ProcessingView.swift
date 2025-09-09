//
//  ProcessingView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 09/09/25.
//

import Foundation
import SwiftUI

struct ProcessingView: View {
    @State private var topImageOffset: CGFloat = -440  // Start above screen
    @State private var bottomImageOffset: CGFloat = 440  // Start below screen
    @State var showText: Bool = false
    @State private var dotCount: Int = 0
    @State private var animationTimer: Timer?
    
    private var displayText: String {
        let dots = String(repeating: ".", count: dotCount)
        return "Generating your Image\(dots)"
    }
    
    var body: some View {
        ZStack {
            Color.secondaryApp.ignoresSafeArea(.all)
            
            ZStack {
                
                if showText {
                    Text(displayText)
                        .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(18)))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.primaryApp.opacity(0.75))
                        .animation(.easeInOut(duration: 0.3), value: dotCount)
                }
                
                VStack(spacing: 0) {
                    // Top image
                    Image(.generateTop)
                        .resizable()
                        .frame(width: ScaleUtility.scaledValue(375), height: ScaleUtility.scaledValue(440))
                        .offset(y: topImageOffset)
                    
                    // Bottom image
                    Image(.generateBottom)
                        .resizable()
                        .frame(width: ScaleUtility.scaledValue(375), height: ScaleUtility.scaledValue(440))
                        .offset(y: bottomImageOffset)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            // Animate images sliding in from top and bottom
            withAnimation(.easeOut(duration: 0.8)) {
                topImageOffset = 28
                bottomImageOffset = -28
            }
            
            // Show text after animation completes and start dot animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                showText = true
                startDotAnimation()
            }
        }
        .onDisappear {
            stopDotAnimation()
        }
    }
    
    private func startDotAnimation() {
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.2)) {
                dotCount = (dotCount % 3) + 1  // Cycles between 1, 2, 3
            }
        }
    }
    
    private func stopDotAnimation() {
        animationTimer?.invalidate()
        animationTimer = nil
    }
}

