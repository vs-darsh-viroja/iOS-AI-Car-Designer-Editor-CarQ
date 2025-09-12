//
//  RedOverlayView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 12/09/25.
//

import Foundation
import SwiftUI


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
