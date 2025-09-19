//
//  CustomSlider.swift
//  Dreamina
//
//  Created by Vimala Jain on 06/09/25.
//


import SwiftUI



// MARK: - Updated Custom Slider (Reusable)
struct ReusableCustomSlider: View {
    @Binding var value: CGFloat
    @Binding var actionType: DrawingTool // Using shared enum
    let range: ClosedRange<CGFloat>

    let sliderWidth: CGFloat = ScaleUtility.scaledValue(ScaleUtility.isPad() ? 400 : 345)
    let trackHeight: CGFloat = 8
    let thumbSize: CGFloat = 32
    let innerDotSize: CGFloat = 8
    let selectionFeedback = UISelectionFeedbackGenerator()
    
    var body: some View {
        let progress = CGFloat((value - range.lowerBound) / (range.upperBound - range.lowerBound))

        ZStack(alignment: .leading) {
            // Track background
            Capsule()
                .fill(.white.opacity(0.2))
                .frame(width: sliderWidth, height: trackHeight)

            // Filled progress
            Capsule()
                .fill(Color.white)
                .frame(width: sliderWidth * progress, height: trackHeight)

            // Thumb
            Image(actionType == .brush ? "brushIcon" : "eraserIcon")
                .resizable()
                .frame(width: ScaleUtility.scaledValue(12), height: ScaleUtility.scaledValue(12))
                .padding(.all, ScaleUtility.scaledSpacing(8))
                .background {
                    RoundedRectangle(cornerRadius: 28)
                        .fill(Color.secondaryApp)
               }
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(Color.primaryApp, lineWidth: 1)
                )
                .offset(x: sliderWidth * progress - thumbSize / 2)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            selectionFeedback.selectionChanged()
                            let location = min(max(gesture.location.x, 0), sliderWidth)
                            let newValue = Double(location / sliderWidth) * (range.upperBound - range.lowerBound) + range.lowerBound
                            value = newValue
                           
                        }
                )
        }
        .frame(width: sliderWidth, height: max(trackHeight, thumbSize))
    }
}
