//
//  BrushControlsView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 12/09/25.
//

import Foundation
import SwiftUI

struct BrushControlsView: View {
    @Binding var currentTool: DrawingTool
    @Binding var brushSize: CGFloat
    let onReset: () -> Void
    
    var body: some View {
        VStack(spacing: ScaleUtility.scaledSpacing(25)) {
            // Tool buttons
            HStack(spacing: ScaleUtility.scaledSpacing(10)) {
                ToolButton(
                    title: "Brush",
                    isSelected: currentTool == .brush,
                    action: { currentTool = .brush }
                )
                
                ToolButton(
                    title: "Eraser",
                    isSelected: currentTool == .eraser,
                    action: { currentTool = .eraser }
                )
                
                Spacer()
                
                ToolButton(
                    title: "Reset",
                    isSelected: false,
                    action: onReset
                )
            }
            
            // Brush size slider
            ReusableCustomSlider(value: $brushSize, actionType: $currentTool, range: 5...50)
        }
        .padding(.horizontal, ScaleUtility.scaledSpacing(15))
    }
}

