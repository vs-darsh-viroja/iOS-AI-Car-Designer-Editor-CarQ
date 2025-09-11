//
//  DrawingCanvasView.swift
//  CarQ
//
//  Created by Assistant on 10/09/25.
//

import SwiftUI

struct DrawingCanvasView: View {
    let image: UIImage
    @Binding var selectedTool: String
    @Binding var brushSize: Double
    
    @State private var brushedAreas: [CGRect] = []
    @State private var currentPath: [CGPoint] = []
    @State private var isDrawing: Bool = false
    @State private var cursorLocation: CGPoint?
    @State private var imageFrame: CGRect = .zero
    @State private var imageSize: CGSize = .zero
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Base image
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .background(
                        GeometryReader { imageGeometry -> Color in
                            let frame = imageGeometry.frame(in: .local)
                            DispatchQueue.main.async {
                                self.imageFrame = frame
                                self.imageSize = frame.size
                            }
                            return Color.clear
                        }
                    )
                    .overlay(
                        ZStack {
                            // Red overlay for brushed areas
                            if !brushedAreas.isEmpty {
                                RedOverlayView(
                                    rects: $brushedAreas,
                                    imageSize: imageFrame.size,
                                    brushSize: CGFloat(brushSize)
                                )
                                .allowsHitTesting(false)
                            }
                            
                            // Interactive brush area
                            BrushInteractionView(
                                brushedAreas: $brushedAreas,
                                selectedTool: selectedTool,
                                brushSize: CGFloat(brushSize),
                                containerSize: imageFrame.size,
                                cursorLocation: $cursorLocation,
                                isDrawing: $isDrawing
                            )
                            
//                            // Cursor indicator
//                            if let location = cursorLocation, isDrawing {
//                                CursorIndicator(
//                                    toolType: selectedTool,
//                                    brushSize: CGFloat(brushSize),
//                                    position: location
//                                )
//                                .allowsHitTesting(false)
//                            }
                        }
                        .clipped()
                    )
            }
        }
    }
    
    func clearDrawing() {
        brushedAreas.removeAll()
        currentPath.removeAll()
        cursorLocation = nil
        isDrawing = false
    }
    
    func getEditedImage() -> UIImage? {
        // Create a rendered image with the overlays
        let renderer = ImageRenderer(content: self)
        return renderer.uiImage
    }
}

// MARK: - Brush Interaction View
struct BrushInteractionView: View {
    @Binding var brushedAreas: [CGRect]
    let selectedTool: String
    let brushSize: CGFloat
    let containerSize: CGSize
    @Binding var cursorLocation: CGPoint?
    @Binding var isDrawing: Bool
    
    @State private var lastLocation: CGPoint?
    
    var body: some View {
        let bounds = CGRect(origin: .zero, size: containerSize)
        
        Color.clear
            .contentShape(Rectangle())
            .frame(width: containerSize.width, height: containerSize.height)
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged { value in
                        let location = value.location
                        guard bounds.contains(location) else { return }
                        
                        cursorLocation = location
                        isDrawing = true
                        
                        if let last = lastLocation {
                            // Interpolate for smooth strokes
                            let dx = location.x - last.x
                            let dy = location.y - last.y
                            let distance = CGFloat(hypot(dx, dy))
                            let step = max(1, brushSize / 6)
                            if distance > step {
                                let steps = Int(distance / step)
                                for i in 1...steps {
                                    let t = CGFloat(i) / CGFloat(steps)
                                    let p = CGPoint(x: last.x + dx * t, y: last.y + dy * t)
                                    if bounds.contains(p) {
                                        handleDrawing(at: p)
                                    }
                                }
                            }
                        }
                        
                        handleDrawing(at: location)
                        lastLocation = location
                    }
                    .onEnded { _ in
                        isDrawing = false
                        lastLocation = nil
                        
                        // Hide cursor after a short delay
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            if !isDrawing {
                                cursorLocation = nil
                            }
                        }
                    }
            )
    }
    
    private func handleDrawing(at location: CGPoint) {
        let half = brushSize / 2
        let rect = CGRect(
            x: location.x - half,
            y: location.y - half,
            width: brushSize,
            height: brushSize
        )
        
        if selectedTool == "Brush" {
            brushedAreas.append(rect)
            // Keep memory in check by coalescing overlapping areas
            if brushedAreas.count > 2000 {
                brushedAreas = coalesced(brushedAreas)
            }
        } else if selectedTool == "Eraser" {
            brushedAreas.removeAll { $0.intersects(rect) }
        }
    }
    
    private func coalesced(_ rects: [CGRect]) -> [CGRect] {
        var output: [CGRect] = []
        for rect in rects {
            if let index = output.firstIndex(where: {
                $0.intersects(rect) || $0.insetBy(dx: -2, dy: -2).intersects(rect)
            }) {
                output[index] = output[index].union(rect)
            } else {
                output.append(rect)
            }
        }
        return output
    }
}

// MARK: - Red Overlay View
struct RedOverlayView: View {
    @Binding var rects: [CGRect]
    var imageSize: CGSize
    var brushSize: CGFloat
    
    private var overlayColor: Color {
        Color(.sRGB, red: 255.0/255.0, green: 115.0/255.0, blue: 115.0/255.0)
    }
    
    var body: some View {
        Canvas { context, _ in
            for rect in rects {
                let path = Path(ellipseIn: rect)
                context.fill(path, with: .color(overlayColor.opacity(0.5)))
            }
        }
        .frame(width: imageSize.width, height: imageSize.height)
        .allowsHitTesting(false)
        .compositingGroup()
    }
}

//// MARK: - Cursor Indicator
//struct CursorIndicator: View {
//    let toolType: String
//    let brushSize: CGFloat
//    let position: CGPoint
//    
//    var body: some View {
//        ZStack {
//            // Size indicator circle
//      
//            Circle()
//                .stroke(toolType == "Brush" ? Color.white : Color.red, lineWidth: 2)
//                .frame(width: brushSize, height: brushSize)
//                .shadow(color: .black.opacity(0.3), radius: 2)
//            
//            // Center dot
//            Circle()
//                .fill(toolType == "Brush" ? Color.white : Color.red)
//                .frame(width: 3, height: 3)
//            
//            // Tool icon above the circle
//            VStack {
//                Image("brushIcon")
//                    .resizable()
//                    .frame(width: 16, height: 16)
//                    .padding(6)
//                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
//                    .shadow(radius: 2)
//                    .offset(y: -brushSize/2 - 18)
//                
//                Spacer()
//            }
//        }
//        .position(position)
//    }
//}

struct DrawingPath {
    var points: [CGPoint]
    let tool: String
    let size: Double
}
