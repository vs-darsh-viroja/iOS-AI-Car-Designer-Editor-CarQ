//
//  DrawingCanvasView.swift
//  CarQ
//
//  Created by Assistant on 10/09/25.
//


import SwiftUI

struct DrawingCanvasView: View {
    let image: UIImage
    @Binding var selectedTool: String // "Brush" or "Eraser"
    @Binding var brushSize: Double

    @State private var paths: [DrawingPath] = []
    @State private var currentPath: DrawingPath?

    // 👇 New: live cursor
    @State private var cursorPoint: CGPoint? = nil
    @State private var isDrawing: Bool = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Base image
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()

                // Drawing overlay
                Canvas { context, size in
                    for path in paths { drawPath(context: context, path: path) }
                    if let currentPath = currentPath { drawPath(context: context, path: currentPath) }
                }
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            let point = value.location
                            cursorPoint = point
                            isDrawing = true

                            if currentPath == nil {
                                currentPath = DrawingPath(points: [point], tool: selectedTool, size: brushSize)
                            } else {
                                currentPath?.points.append(point)
                            }
                        }
                        .onEnded { _ in
                            if let path = currentPath { paths.append(path) }
                            currentPath = nil
                            isDrawing = false
                            // Optional: keep the cursor visible for a flash, then hide
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                cursorPoint = nil
                            }
                        }
                )

                // 👇 Live tool cursor that follows the finger
                if let p = cursorPoint {
                    ZStack {
                        // Halo matching brush size for precise highlight
                        Circle()
                            .strokeBorder(selectedTool == "Brush" ? Color.white.opacity(0.9) : Color.black.opacity(0.6),
                                          lineWidth: 2)
                            .frame(width: max(brushSize, 6), height: max(brushSize, 6))
                            .shadow(radius: 2)

                        // Tool icon
                        Image(selectedTool == "Brush" ? .brushIcon : .eraserIcon)
                            .resizable()
                            .frame(width: 22, height: 22)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                            .shadow(radius: 3)
                            .offset(y: -max(brushSize, 6) * 0.8) // float just above the halo
                    }
                    .position(p)
                    .animation(.easeOut(duration: 0.08), value: p)
                    .allowsHitTesting(false)
                }
            }
        }
    }

    private func drawPath(context: GraphicsContext, path: DrawingPath) {
        guard path.points.count > 1 else { return }
        let cgPath = CGMutablePath()
        cgPath.move(to: path.points[0])
        for i in 1..<path.points.count { cgPath.addLine(to: path.points[i]) }

        if path.tool == "Brush" {
            context.stroke(
                Path(cgPath),
                with: .color(.white.opacity(0.6)),
                style: StrokeStyle(lineWidth: CGFloat(path.size), lineCap: .round, lineJoin: .round)
            )
        } else {
            // NOTE: For a true eraser, draw into a separate layer/mask; this clear stroke is a visual placeholder.
            context.stroke(
                Path(cgPath),
                with: .color(.clear),
                style: StrokeStyle(lineWidth: CGFloat(path.size), lineCap: .round, lineJoin: .round)
            )
        }
    }

    func clearDrawing() {
        paths.removeAll()
        currentPath = nil
    }

    func getEditedImage() -> UIImage? {
        let renderer = ImageRenderer(content: self)
        return renderer.uiImage
    }
}

struct DrawingPath {
    var points: [CGPoint]
    let tool: String
    let size: Double
}
