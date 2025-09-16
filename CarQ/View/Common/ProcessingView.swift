//
//  ProcessingView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 09/09/25.
//

import Foundation
import SwiftUI

struct ProcessingView: View {
    @State private var topImageOffset: CGFloat = -440
    @State private var bottomImageOffset: CGFloat = 440
    @State var showText: Bool = false
    @State private var dotCount: Int = 0
    @State private var animationTimer: Timer?
    
    // 👇 New state for steering image movement
    @State private var steeringAngle: Double = 0   // NEW
  
    
    private var displayText: String {
        let dots = String(repeating: ".", count: dotCount)
        return "Generating your Image\(dots)"
    }
    
    @ObservedObject var viewModel: GenerationViewModel
    var onBack: () -> Void
    var onAppear:() -> Void
    var onClose: () -> Void
    
    var body: some View {
        ZStack {
            Color.secondaryApp.ignoresSafeArea(.all)
            
            ZStack {
                if showText {
                    Image(.steeringIcon2)
                        .resizable()
                        .frame(width: isIPad
                               ? ScaleUtility.scaledValue(453)
                               : ScaleUtility.scaledValue(253),
                               height: isIPad
                               ? ScaleUtility.scaledValue(453)
                               : ScaleUtility.scaledValue(253))
                        // 👇 Apply oscillating horizontal offset
                        .rotationEffect(.degrees(steeringAngle))      // NEW
                        .onAppear { startSteeringRotation() }         // NEW
                        .offset(y: isIPad
                                ? ScaleUtility.scaledSpacing(48)
                                : ScaleUtility.scaledSpacing(28))
                    
                    Text(displayText)
                        .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(18)))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.primaryApp.opacity(0.75))
                        .animation(.easeInOut(duration: 0.3), value: dotCount)
                }
                
                VStack(spacing: 0) {
                    Image(.generateTop)
                        .resizable()
                        .frame(width: isIPad
                               ? 815 * ipadWidthRatio
                               : ScaleUtility.scaledValue(375),
                               height: isIPad
                               ? 750 * ipadWidthRatio
                               : ScaleUtility.scaledValue(440))
                        .offset(y: ScaleUtility.scaledSpacing(topImageOffset))
                    
                    Image(.generateBottom)
                        .resizable()
                        .frame(width: isIPad
                               ? 815 * ipadWidthRatio
                               : ScaleUtility.scaledValue(375),
                               height: isIPad
                               ? 750 * ipadWidthRatio
                               : ScaleUtility.scaledValue(440))
                        .offset(y: ScaleUtility.scaledSpacing(bottomImageOffset))
                }
            }
        }
        .navigationBarHidden(true)
        .background(Color.secondaryApp.edgesIgnoringSafeArea(.all))
        .onAppear {
            onAppear()
            withAnimation(.easeOut(duration: 0.8)) {
                topImageOffset = isIPad ? 42 : 28
                bottomImageOffset = isIPad ? -42 : -28
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                showText = true
                startDotAnimation()
            }
        }
        .onDisappear {
                stopDotAnimation()
                steeringAngle = 0  // optional reset
            }
        .navigationDestination(isPresented: $viewModel.shouldNavigateToResult) {
            ResultView(viewModel: viewModel) { onBack() } onClose: {
                onClose()
            }
        }
        .onChange(of: viewModel.shouldReturn) { goBack in
            if goBack { onBack() }
        }
    }
    
    // MARK: - Animations
    
    private func startDotAnimation() {
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.2)) {
                dotCount = (dotCount % 3) + 1
            }
        }
    }
    
    private func stopDotAnimation() {
        animationTimer?.invalidate()
        animationTimer = nil
    }
    
    private func startSteeringRotation() {
         steeringAngle = -8 // start slightly left
         withAnimation(.easeInOut(duration: 2.6).repeatForever(autoreverses: true)) {
             steeringAngle = 8 // oscillate to the right (±8°)
         }
     }
}

// MARK: - Preview

struct ProcessingView_Previews: PreviewProvider {
    static var previews: some View {
        ProcessingView(
            viewModel: GenerationViewModel(),
            onBack: { },
            onAppear: { },
            onClose: { }
        )
        .preferredColorScheme(.dark) // optional, matches your app theme
    }
}
