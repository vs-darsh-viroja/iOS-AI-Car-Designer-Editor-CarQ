//
//  CarTypesView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 09/09/25.
//

import Foundation
import SwiftUI

struct CarTypesView: View {
    @Binding var selectedCarType: String
    
    struct CarType {
        let name: String
        let imageName: String
    }
    
    private let carTypes: [CarType] = [
        .init(name: "Sedan", imageName: "dummyCarImage"),
        .init(name: "SUV", imageName: "dummyCarImage"),
        .init(name: "Hatchback", imageName: "dummyCarImage"),
        .init(name: "Coupe", imageName: "dummyCarImage"),
        .init(name: "Convertible", imageName: "dummyCarImage"),
        .init(name: "Wagon", imageName: "dummyCarImage"),
        .init(name: "Pickup", imageName: "dummyCarImage"),
        .init(name: "Minivan", imageName: "dummyCarImage"),
        .init(name: "Sports Car", imageName: "dummyCarImage"),
        .init(name: "Crossover", imageName: "dummyCarImage")
    ]
    
    var body: some View {
        VStack(spacing: ScaleUtility.scaledSpacing(13)) {
            Text("Type")
                .font(FontManager.ChakraPetchSemiBoldFont(size: .scaledFontSize(18)))
                .multilineTextAlignment(.center)
                .foregroundColor(Color.primaryApp)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, ScaleUtility.scaledSpacing(15))
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: ScaleUtility.scaledSpacing(11)) {
                    ForEach(carTypes.indices, id: \.self) { index in
                        let carType = carTypes[index]
                        let isSelected = selectedCarType == carType.name
                        
                        Button {
                            selectedCarType = carType.name
                        } label: {
                            VStack {
                                ZStack {
                                    Image(isSelected ? .carStroke2 : .carStroke1)
                                        .resizable()
                                        .frame(width: ScaleUtility.scaledValue(100), height: ScaleUtility.scaledValue(100))
                                    
                                    Image(carType.imageName)
                                        .resizable()
                                        .frame(width: ScaleUtility.scaledValue(90), height: ScaleUtility.scaledValue(90))
                                }
                                
                                Text(carType.name)
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
