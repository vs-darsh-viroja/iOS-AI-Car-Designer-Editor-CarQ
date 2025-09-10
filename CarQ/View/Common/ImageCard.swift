//
//  ImageCard.swift
//  CarQ
//
//  Created by Purvi Sancheti on 10/09/25.
//

import Foundation
import SwiftUI

struct ImageCard: View {
    @Binding var selectedEraser: String
    let image: Image
    let uiImage: UIImage? // Add UIImage for drawing
    var onRemove: () -> Void
    var onReset: () -> Void // Add reset callback
    let notificationFeedback = UINotificationFeedbackGenerator()
    
    @State private var brushSize: Double = 20 // Brush/Eraser size
    @State private var drawingCanvasRef: DrawingCanvasView?

    var body: some View {
        
        VStack(spacing: ScaleUtility.scaledSpacing(15)) {
            // Base image card with drawing capability
            ZStack {
                if let uiImage = uiImage {
                    DrawingCanvasView(
                        image: uiImage,
                        selectedTool: $selectedEraser,
                        brushSize: $brushSize
                    )
                    .frame(maxWidth: .infinity)
                    .frame(height: isIPad ? ScaleUtility.scaledValue(645) : ScaleUtility.scaledValue(345))
                    .padding(.horizontal, ScaleUtility.scaledSpacing(15))
                } else {
                    image
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal, ScaleUtility.scaledSpacing(15))
                        .frame(maxWidth: .infinity)
                        .frame(height: isIPad ? ScaleUtility.scaledValue(645) : ScaleUtility.scaledValue(345))
                }

            }
            .overlay {
                // Background overlay
                Image(.imageBg)
                    .resizable()
                    .scaledToFit()
            }
            .overlay(alignment: .topTrailing) {
                Button(action:{
                    notificationFeedback.notificationOccurred(.success)
                    onRemove()
                }) {
                    Image(.crossIcon2)
                        .resizable()
                        .frame(width: ScaleUtility.scaledValue(18), height: ScaleUtility.scaledValue(18))
                        .padding(.all, ScaleUtility.scaledSpacing(5))
                        .background(Color.primaryApp.opacity(0.1))
                        .cornerRadius(30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.primaryApp.opacity(0.2), lineWidth: 1)
                        )
                }
                .padding(.top,ScaleUtility.scaledSpacing(15))
                .offset(x: ScaleUtility.scaledSpacing(-30))
            }
            
            // Brush/Eraser selection and size controls
            HStack {
                HStack(spacing: ScaleUtility.scaledSpacing(10)) {
                    Button {
                        selectedEraser = "Brush"
                    } label: {
                        Text("Brush")
                            .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(14)))
                            .foregroundColor(Color.primaryApp.opacity(selectedEraser == "Brush" ? 1 : 0.4))
                            .padding(.vertical, ScaleUtility.scaledSpacing(10))
                            .padding(.horizontal, ScaleUtility.scaledSpacing(20))
                            .background {
                                Image(.selectionBg2)
                                    .resizable()
                                    .frame(width: ScaleUtility.scaledValue(78),height: ScaleUtility.scaledValue(38))
                                    .overlay {
                                        if selectedEraser == "Brush" {
                                            Image(.selectionOverlay2)
                                                .resizable()
                                                .frame(width: ScaleUtility.scaledValue(78),height: ScaleUtility.scaledValue(38))
                                        }
                                    }
                            }
                    }

                    Button {
                        selectedEraser = "Eraser"
                    } label: {
                        Text("Eraser")
                            .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(14)))
                            .foregroundColor(Color.primaryApp.opacity(selectedEraser == "Eraser" ? 1 : 0.4))
                            .padding(.vertical, ScaleUtility.scaledSpacing(10))
                            .padding(.horizontal, ScaleUtility.scaledSpacing(20))
                            .background {
                                Image(.selectionBg2)
                                    .resizable()
                                    .frame(width: ScaleUtility.scaledValue(78),height: ScaleUtility.scaledValue(38))
                                    .overlay {
                                        if selectedEraser == "Eraser" {
                                            Image(.selectionOverlay2)
                                                .resizable()
                                                .frame(width: ScaleUtility.scaledValue(78),height: ScaleUtility.scaledValue(38))
                                        }
                                    }
                            }
                    }
                }
                
                Spacer()
                
                Button(action: {
                    onReset()
                }) {
                    HStack(spacing: ScaleUtility.scaledSpacing(5)) {
                        Image(.resetIcon)
                            .resizable()
                            .frame(width: ScaleUtility.scaledValue(20), height: ScaleUtility.scaledValue(20))
                        
                        Text("Reset")
                            .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(14)))
                            .foregroundColor(Color.primaryApp.opacity(0.5))
                    }
                    .padding(.horizontal, ScaleUtility.scaledSpacing(15))
                    .padding(.vertical, ScaleUtility.scaledSpacing(10))
                    .background(
                        Image(.resetBg)
                            .resizable()
                            .frame(width: ScaleUtility.scaledValue(93),height: ScaleUtility.scaledValue(40))
                    )
                }
            }
            .padding(.horizontal, ScaleUtility.scaledSpacing(15))
           
                
                CustomSlider(
                    value: $brushSize,
                    minValue: 5,
                    maxValue: 50,
                    thumbImageName: selectedEraser == "Brush" ? "brushIcon" : "eraserIcon" // Replace with your custom thumb image
                )
                .padding(.horizontal, ScaleUtility.scaledSpacing(15))
            
        }
    }
}
