//
//  CustomSlider.swift
//  CarQ
//
//  Created by Assistant on 10/09/25.
//

import SwiftUI

struct CustomSlider: View {
    @Binding var value: Double
    let minValue: Double
    let maxValue: Double
    let thumbImageName: String
    
    @State private var isDragging = false
    
    var body: some View {
        GeometryReader { geometry in
            let trackWidth = geometry.size.width - ScaleUtility.scaledValue(30) // Account for thumb size
            let thumbPosition = CGFloat((value - minValue) / (maxValue - minValue)) * trackWidth
            
            ZStack(alignment: .leading) {
                // Track background (progress left - 0.2 opacity)
                Rectangle()
                    .fill(Color.primaryApp.opacity(0.2))
                    .frame(height: ScaleUtility.scaledValue(8))
                    .padding(.horizontal, ScaleUtility.scaledSpacing(15))
                
                // Progress track (white)
                Rectangle()
                    .fill(Color.primaryApp)
                    .frame(width: thumbPosition + ScaleUtility.scaledValue(15), height: ScaleUtility.scaledValue(8))
                    .padding(.leading, ScaleUtility.scaledSpacing(15))
                
                // Custom thumb
                Image(thumbImageName)
                    .resizable()
                    .frame(width: ScaleUtility.scaledValue(12), height: ScaleUtility.scaledValue(12))
                    .padding(.all, ScaleUtility.scaledSpacing(8))
                    .background {
                        RoundedRectangle(cornerRadius: 28)
                            .fill(Color.secondaryApp.opacity(0.5))
                   }
                    .overlay(
                        RoundedRectangle(cornerRadius: 28)
                            .stroke(Color.primaryApp, lineWidth: 1)
                    )
                    .offset(x: thumbPosition)
                    .padding(.leading, ScaleUtility.scaledSpacing(15))
                    .scaleEffect(isDragging ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 0.1), value: isDragging)
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { dragValue in
                        isDragging = true
                        let newPosition = max(0, min(trackWidth, dragValue.location.x - ScaleUtility.scaledValue(15)))
                        let newValue = minValue + (maxValue - minValue) * Double(newPosition / trackWidth)
                        value = max(minValue, min(maxValue, newValue))
                    }
                    .onEnded { _ in
                        isDragging = false
                    }
            )
        }
        .frame(height: ScaleUtility.scaledValue(30))
    }
}

// Preview
#Preview {
    VStack(spacing: 30) {
   
        CustomSlider(
            value: .constant(25),
            minValue: 5,
            maxValue: 50,
            thumbImageName: "eraserIcon"
        )
        .background(Color.gray) // For preview visibility
    }
    .padding()
}
