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
        .init(name: "Alloy Wheels", imageName: "AlloyWheels"),
        .init(name: "Custom Exhaust", imageName: "CustomExhaust"),
        .init(name: "Decals", imageName: "Decals"),
        .init(name: "Neon Lights", imageName: "NeonLights"),
        .init(name: "Roof Rack", imageName: "RoofRack"),
        .init(name: "Side Skirts", imageName: "SideSkirts"),
        .init(name: "Spoiler", imageName: "Spoiler"),
    ]
    let selectionFeedback = UISelectionFeedbackGenerator()
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
                            selectionFeedback.selectionChanged()
                            if selectedAccessory == accessory.name {
                                selectedAccessory = ""
                            } else {
                                selectedAccessory = accessory.name
                            }
                        } label: {
                            VStack(spacing: ScaleUtility.scaledSpacing(5)) {
                                ZStack {
                                    Image(isSelected ? .carStroke2 : .carStroke1)
                                        .resizable()
                                        .frame(width: ScaleUtility.scaledValue(100), height: ScaleUtility.scaledValue(100))
                                    
                                    Image(accessory.imageName)
                                        .resizable()
                                        .frame(width: ScaleUtility.scaledValue(90), height: ScaleUtility.scaledValue(90))
                                        .clipShape(Circle())
                                }
                                
                                Text(accessory.name)
                                    .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(14)))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color.primaryApp)
                                    .frame(width: isIPad ? ScaleUtility.scaledValue(114) : ScaleUtility.scaledValue(104))
                                    .frame(height:ScaleUtility.scaledValue(50),alignment: .top)
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
