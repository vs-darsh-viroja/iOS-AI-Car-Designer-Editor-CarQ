//
//  CursorIndicator.swift
//  CarQ
//
//  Created by Purvi Sancheti on 12/09/25.
//

import Foundation
import SwiftUI

// MARK: - Reusable Cursor Indicator
struct CursorIndicator: View {
    let toolType: DrawingTool
    let brushSize: CGFloat
    let position: CGPoint
    
    var body: some View {
        ZStack {
            // Size indicator circle
            Image(toolType == .brush ? .brushIcon2 : .eraserIcon2)
                .resizable()
                .frame(width: ScaleUtility.scaledValue(brushSize), height: ScaleUtility.scaledValue(brushSize))
        }
        .position(position)
    }
}
