//
//  DrawingCanvasView.swift
//  CarQ
//
//  Created by Assistant on 10/09/25.
//

import SwiftUI

// MARK: - Reusable Drawing Canvas View
struct DrawingCanvasView: View {
    let image: UIImage
    @Binding var currentTool: DrawingTool
    @Binding var brushSize: CGFloat
    
    @State private var brushedAreas: [CGRect] = []
    @State private var imageFrame: CGRect = .zero
    @State private var needsRedraw = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .background(
                        GeometryReader { imageGeometry -> Color in
                            let frame = imageGeometry.frame(in: .local)
                            DispatchQueue.main.async {
                                self.imageFrame = frame
                            }
                            return Color.clear
                        }
                    )
                    .overlay {
                        
                        if isIPad {
                            
                            Image(.imageBg)
                                .resizable()
                                .frame(width: ScaleUtility.scaledValue(647.01) ,
                                       height: ScaleUtility.scaledValue(346.99463))
                               
                            
                        }
                        else {
                            
                            Image(.imageBg)
                                .resizable()
                                .scaledToFit()
                       
                        }
                    }
                    .overlay(
                        ZStack {
                            // Red overlay for brushed areas
                            if !brushedAreas.isEmpty || needsRedraw {
                                RedOverlayView(
                                    rects: $brushedAreas,
                                    imageSize: imageFrame.size,
                                    brushSize: brushSize
                                )
                                .allowsHitTesting(false)
                            }
                            
                            // Interactive brush area
                            BrushAreaView(
                                brushedAreas: $brushedAreas,
                                currentTool: $currentTool,
                                brushSize: $brushSize,
                                containerSize: imageFrame.size,
                                imageFrame: $imageFrame
                            )
                        }
                        .clipped()
                    )
                    .cornerRadius(15)
            }
            .frame(width: geometry.size.width, height: min(geometry.size.height, ScaleUtility.scaledValue(345)))
        }
    }
    
    // Public methods for external control
    func clearDrawing() {
        brushedAreas.removeAll()
        needsRedraw.toggle()
    }
    
    func getBrushedAreas() -> [CGRect] {
        return brushedAreas
    }
    
    func setBrushedAreas(_ areas: [CGRect]) {
        brushedAreas = areas
        needsRedraw.toggle()
    }
}

