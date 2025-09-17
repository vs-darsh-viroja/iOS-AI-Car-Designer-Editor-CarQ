//
//  FilterView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 17/09/25.
//

import Foundation
import SwiftUI

struct FilterView: View {
    
    @Binding var selectedOption: String
    var filterOption = ["All",
                           "Minimal",
                           "Luxury",
                           "Sporty",
                           "Muscular",
                           "Futuristic",
                           "Retro"]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: ScaleUtility.scaledSpacing(5)) {
                ForEach(Array(filterOption.enumerated()), id: \.offset) { index, option in
                    let isSelected = selectedOption == option
                    let isFirstOption = index == 0
                    
                    ZStack {
                        Image(isFirstOption ? .filterBg1 : .filterBg2)
                            .resizable()
                            .frame(width: isFirstOption ? ScaleUtility.scaledValue(70) : ScaleUtility.scaledValue(98),
                                   height: ScaleUtility.scaledValue(37))
                        
                        Text(option)
                            .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(14)))
                            .foregroundColor(.white.opacity(isSelected ? 1 : 0.5))
                            .frame(width: isFirstOption ? ScaleUtility.scaledValue(20) : ScaleUtility.scaledValue(66))
                  
                        
                    }
                    .overlay {
                        if isSelected {
                            Image(isFirstOption ? .filterOverlay1 : .filterOverlay2)
                                .resizable()
                                .frame(width: isFirstOption ? ScaleUtility.scaledValue(70) : ScaleUtility.scaledValue(98),
                                       height: ScaleUtility.scaledValue(37))
                        }
                    }
                    .onTapGesture {
                        selectedOption = option
                    }
                }
            }
            .padding(.horizontal, ScaleUtility.scaledSpacing(15))
        }
    }
}
