//
//  AccessoriesView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 09/09/25.
//

import Foundation
import SwiftUI

struct AccessoriesView: View {
    @Binding var selectedAccessory: String
    
    struct Accessory {
        let name: String
        let imageName: String
    }
    
    private let accessories: [Accessory] = [
        .init(name: "Spoiler", imageName: "dummyCarImage"),
        .init(name: "Hood Scoop", imageName: "dummyCarImage"),
        .init(name: "Side Skirts", imageName: "dummyCarImage"),
        .init(name: "Roof Rack", imageName: "dummyCarImage"),
        .init(name: "Bull Bar", imageName: "dummyCarImage"),
        .init(name: "Mudflaps", imageName: "dummyCarImage"),
        .init(name: "Sunroof", imageName: "dummyCarImage"),
        .init(name: "LED Strips", imageName: "dummyCarImage"),
        .init(name: "Chrome Trim", imageName: "dummyCarImage"),
        .init(name: "Diffuser", imageName: "dummyCarImage"),

    ]
    
    var body: some View {
        VStack(spacing: ScaleUtility.scaledSpacing(13)) {
            Text("Accessories")
                .font(FontManager.ChakraPetchSemiBoldFont(size: .scaledFontSize(18)))
                .multilineTextAlignment(.center)
                .foregroundColor(Color.primaryApp)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, ScaleUtility.scaledSpacing(15))
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: ScaleUtility.scaledSpacing(11)) {
                    ForEach(accessories.indices, id: \.self) { index in
                        let accessory = accessories[index]
                        let isSelected = selectedAccessory == accessory.name
                        
                        Button {
                            selectedAccessory = accessory.name
                        } label: {
                            VStack {
                                ZStack {
                                    Image(isSelected ? .carStroke2 : .carStroke1)
                                        .resizable()
                                        .frame(width: ScaleUtility.scaledValue(100), height: ScaleUtility.scaledValue(100))
                                    
                                    Image(accessory.imageName)
                                        .resizable()
                                        .frame(width: ScaleUtility.scaledValue(90), height: ScaleUtility.scaledValue(90))
                                }
                                
                                Text(accessory.name)
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
