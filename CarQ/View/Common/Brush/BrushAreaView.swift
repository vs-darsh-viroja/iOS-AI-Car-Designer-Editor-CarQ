
//
//  BrushSystemComponents.swift
//  CarQ
//
//  Created by Assistant on 12/09/25.
//

import SwiftUI

// MARK: - Shared Drawing Tool Enum
public enum DrawingTool {
    case brush
    case eraser
}

// MARK: - Reusable Brush Area View
struct BrushAreaView: View {
    @Binding var brushedAreas: [CGRect]
    @Binding var currentTool: DrawingTool
    @Binding var brushSize: CGFloat
    var containerSize: CGSize
    @Binding var imageFrame: CGRect

    @State private var lastLocation: CGPoint?
    @State private var isDrawing = false
    @State private var cursorLocation: CGPoint?
    let selectionFeedback = UISelectionFeedbackGenerator()
    var body: some View {
        let bounds = CGRect(origin: .zero, size: containerSize)

        ZStack {
            Color.clear
                .contentShape(Rectangle())
                .frame(width: containerSize.width, height: containerSize.height)
                .gesture(
                    DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onChanged { value in
                            selectionFeedback.selectionChanged()
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
                                        if bounds.contains(p) { handleDrawing(at: p) }
                                    }
                                }
                            }

                            handleDrawing(at: location)
                            lastLocation = location
                        }
                        .onEnded { _ in
                            lastLocation = nil
                            
                            // Hide cursor after a short delay
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                if !isDrawing {
                                    withAnimation(.easeOut(duration: 0.2)) {
                                        cursorLocation = nil
                                    }
                                }
                            }
                            isDrawing = false
                        }
                )
            
            // Cursor indicator
            if let location = cursorLocation {
                CursorIndicator(
                    toolType: currentTool,
                    brushSize: brushSize,
                    position: location
                )
                .allowsHitTesting(false)
                .animation(.easeInOut(duration: 0.1), value: cursorLocation)
            }
        }
    }

    private func handleDrawing(at location: CGPoint) {
        let half = brushSize / 2
        let rect = CGRect(x: location.x - half, y: location.y - half, width: brushSize, height: brushSize)

        switch currentTool {
        case .brush:
            brushedAreas.append(rect)
            // Optional: coalesce recent overlapping rects to avoid huge arrays
            if brushedAreas.count > 3000 {
                brushedAreas = coalesced(brushedAreas)
            }
        case .eraser:
            brushedAreas.removeAll { $0.intersects(rect) }
        }
    }

    private func coalesced(_ rects: [CGRect]) -> [CGRect] {
        // Very lightweight coalescing to keep memory in check
        var out: [CGRect] = []
        for r in rects {
            if let i = out.firstIndex(where: { $0.intersects(r) || $0.insetBy(dx: -2, dy: -2).intersects(r) }) {
                out[i] = out[i].union(r)
            } else {
                out.append(r)
            }
        }
        return out
    }
}

