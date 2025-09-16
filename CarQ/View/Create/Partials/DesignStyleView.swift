//
//  DesignStylesView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 09/09/25.
//

import Foundation
import SwiftUI

struct DesignStylesView: View {
    @Binding var selectedDesignStyle: String
    
    struct DesignStyle {
        let name: String
        let imageName: String
    }
    
    private let designStyles: [DesignStyle] = [
        .init(name: "Muscle", imageName: "dummyCarImage"),
        .init(name: "Japanese", imageName: "dummyCarImage"),
        .init(name: "Modern", imageName: "dummyCarImage"),
        .init(name: "Luxurious", imageName: "dummyCarImage"),
        .init(name: "Classic", imageName: "dummyCarImage"),
        .init(name: "Sports", imageName: "dummyCarImage"),
        .init(name: "Retro", imageName: "dummyCarImage"),
        .init(name: "Futuristic", imageName: "dummyCarImage"),
        .init(name: "Off-Road", imageName: "dummyCarImage"),
        .init(name: "Racing", imageName: "dummyCarImage"),
        .init(name: "Minimalist", imageName: "dummyCarImage"),
        .init(name: "Aggressive", imageName: "dummyCarImage")
    ]
    
    var body: some View {
        VStack(spacing: ScaleUtility.scaledSpacing(13)) {
            Text("Design Style")
                .font(FontManager.ChakraPetchSemiBoldFont(size: .scaledFontSize(18)))
                .multilineTextAlignment(.center)
                .foregroundColor(Color.primaryApp)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, ScaleUtility.scaledSpacing(15))
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: ScaleUtility.scaledSpacing(11)) {
                    ForEach(designStyles.indices, id: \.self) { index in
                        let designStyle = designStyles[index]
                        let isSelected = selectedDesignStyle == designStyle.name
                        
                        Button {
                            selectedDesignStyle = designStyle.name
                        } label: {
                            VStack {
                                ZStack {
                                    Image(isSelected ? .carStroke2 : .carStroke1)
                                        .resizable()
                                        .frame(width: ScaleUtility.scaledValue(100), height: ScaleUtility.scaledValue(100))
                                    
                                    Image(designStyle.imageName)
                                        .resizable()
                                        .frame(width: ScaleUtility.scaledValue(90), height: ScaleUtility.scaledValue(90))
                                }
                                
                                Text(designStyle.name)
                                    .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(14)))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color.primaryApp)
                                    .frame(width: isIPad ? ScaleUtility.scaledValue(114) : ScaleUtility.scaledValue(104))
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, ScaleUtility.scaledSpacing(15))
            }
        }
    }
}
