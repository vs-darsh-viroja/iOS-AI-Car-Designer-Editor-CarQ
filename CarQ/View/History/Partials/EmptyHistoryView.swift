//
//  EmptyHistoryView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 11/09/25.
//

import Foundation
import SwiftUI

struct EmptyHistoryView: View {
    var body: some View {
        VStack(spacing: ScaleUtility.scaledSpacing(10)) {
            Image(.emptyHistoryIcon)
                .resizable()
                .frame(width: ScaleUtility.scaledValue(72), height: ScaleUtility.scaledValue(72))
            
            Text("Nothing to See here...")
                .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(18)))
                .multilineTextAlignment(.center)
                .foregroundColor(Color.primaryApp.opacity(0.2))
        }
        .padding(.top, ScaleUtility.scaledSpacing(150))
    }
}
