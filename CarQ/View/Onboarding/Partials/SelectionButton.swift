//
//  SelectionButton.swift
//  CarQ
//
//  Created by Purvi Sancheti on 18/09/25.
//

import Foundation
import SwiftUI

struct SelectionButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(.selectionBg)
                .resizable()
                .scaledToFit()
                .frame(width: isIPad ? 367  * ipadWidthRatio : ScaleUtility.scaledValue(167),
                       height:  isIPad ? 160 * ipadHeightRatio : ScaleUtility.scaledValue(60))
                .overlay {
                    if isSelected {
                        Image(.selectionOverlay)
                            .resizable()
                            .scaledToFit()
                            .frame(width: isIPad ? 367  * ipadWidthRatio : ScaleUtility.scaledValue(167),
                                   height:  isIPad ? 160 * ipadHeightRatio : ScaleUtility.scaledValue(60))
                    }
                }
                .overlay {
                    Text(title)
                        .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(16)))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.primaryApp.opacity(isSelected ? 1 : 0.5))
                }
        }
    }
}
