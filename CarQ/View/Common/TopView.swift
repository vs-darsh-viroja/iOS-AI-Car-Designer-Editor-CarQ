//
//  TopView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 08/09/25.
//

import Foundation
import SwiftUI

struct TopView: View {
    
    var title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(FontManager.ChakraPetchSemiBoldFont(size: .scaledFontSize(24)))
                .foregroundColor(Color.primaryApp)
            
            Spacer()
            
            Image(.crownIcon)
                .resizable()
                .frame(width: ScaleUtility.scaledValue(42), height: ScaleUtility.scaledValue(42))
        }
        .padding(.horizontal, ScaleUtility.scaledSpacing(15))
    }
}
