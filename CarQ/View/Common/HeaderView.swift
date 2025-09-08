//
//  HeaderView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 08/09/25.
//

import Foundation
import SwiftUI

struct HeaderView: View {
    var text: String
    var onBack: () -> Void
    
    var body: some View {
        HStack {
            HStack(spacing: ScaleUtility.scaledSpacing(15)) {
                Button {
                    onBack()
                } label: {
                    Image(.backIcon)
                        .resizable()
                        .frame(width: ScaleUtility.scaledValue(24), height:  ScaleUtility.scaledValue(24))
                }
                
                Text(text)
                    .font(FontManager.ChakraPetchMediumFont(size: .scaledFontSize(24)))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            Image(.crownIcon)
                .resizable()
                .frame(width: ScaleUtility.scaledValue(42), height: ScaleUtility.scaledValue(42))
        }
        .padding(.horizontal, ScaleUtility.scaledSpacing(15))
    }
}
