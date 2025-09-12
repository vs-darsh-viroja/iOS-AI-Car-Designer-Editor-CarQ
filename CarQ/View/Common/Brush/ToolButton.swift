//
//  ToolButton.swift
//  CarQ
//
//  Created by Purvi Sancheti on 11/09/25.
//

import Foundation

import SwiftUI

struct ToolButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing:title == "Reset" ? 5 : 0 ) {
                if title == "Reset" {
                    Image(.resetIcon)
                        .resizable()
                        .frame(width: ScaleUtility.scaledValue(20), height: ScaleUtility.scaledValue(20))
                }
                
                Text(title)
                    .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(14)))
                    .foregroundColor(Color.primaryApp.opacity(title == "Brush" ? 1 : 0.4))
     
            }
            .padding(.vertical, ScaleUtility.scaledSpacing(10))
            .padding(.horizontal, ScaleUtility.scaledSpacing(15))
            .background {
                Image(.selectionBg2)
                    .resizable()
                    .frame(width: ScaleUtility.scaledValue(78),height: ScaleUtility.scaledValue(38))
                    .overlay {
                        if isSelected {
                            Image(.selectionOverlay2)
                                .resizable()
                                .frame(width: ScaleUtility.scaledValue(78),height: ScaleUtility.scaledValue(38))
                        }
                        else if title == "Reset" {
                            Image(.resetBg)
                                .resizable()
                                .frame(width: ScaleUtility.scaledValue(93),height: ScaleUtility.scaledValue(40))
                        }
                    }
            }
        }
    }
}
