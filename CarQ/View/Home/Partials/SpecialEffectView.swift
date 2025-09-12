//
//  SpecialEffectView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 12/09/25.
//

import Foundation
import SwiftUI

struct SpecialEffectView: View {
    @Binding var selectedEffect: String
    
    struct EffectType {
        let name: String
        let imageName: String
    }
    
    private let effectTypes: [EffectType] = [
        .init(name: "Metallic", imageName: "dummyCarImage"),
        .init(name: "Pearl", imageName: "dummyCarImage"),
        .init(name: "Matte", imageName: "dummyCarImage"),
        .init(name: "Glossy", imageName: "dummyCarImage"),
        .init(name: "Chrome", imageName: "dummyCarImage"),
        .init(name: "Satin", imageName: "dummyCarImage"),
        .init(name: "Sparkle", imageName: "dummyCarImage"),
        .init(name: "Gradient", imageName: "dummyCarImage"),
        .init(name: "Two-Tone", imageName: "dummyCarImage"),
        .init(name: "Racing Stripes", imageName: "dummyCarImage")
    ]
    
    var body: some View {
        VStack(spacing: ScaleUtility.scaledSpacing(13)) {
            Text("Special Effects")
                .font(FontManager.ChakraPetchSemiBoldFont(size: .scaledFontSize(18)))
                .multilineTextAlignment(.center)
                .foregroundColor(Color.primaryApp)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, ScaleUtility.scaledSpacing(15))
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: ScaleUtility.scaledSpacing(11)) {
                    ForEach(effectTypes.indices, id: \.self) { index in
                        let effectType = effectTypes[index]
                        let isSelected = selectedEffect == effectType.name
                        
                        Button {
                            selectedEffect = effectType.name
                        } label: {
                            VStack {
                                ZStack {
                                    Image(isSelected ? .carStroke2 : .carStroke1)
                                        .resizable()
                                        .frame(width: ScaleUtility.scaledValue(100), height: ScaleUtility.scaledValue(100))
                                    
                                    Image(effectType.imageName)
                                        .resizable()
                                        .frame(width: ScaleUtility.scaledValue(90), height: ScaleUtility.scaledValue(90))
                                }
                                
                                Text(effectType.name)
                                    .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(14)))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color.primaryApp)
                                    .frame(width: ScaleUtility.scaledValue(104))
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
