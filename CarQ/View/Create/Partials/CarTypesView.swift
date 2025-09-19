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
        .init(name: "Classic", imageName: "Classic"),
        .init(name: "Coupe", imageName: "Coupe"),
        .init(name: "Luxury", imageName: "Luxury"),
        .init(name: "Minivan", imageName: "Minivan"),
        .init(name: "Motorcycle", imageName: "Motorcycle"),
        .init(name: "Pickup Truck", imageName: "PickupTruck"),
        .init(name: "Sedan", imageName: "Sedan"),
        .init(name: "Sport", imageName: "Sports"),
        .init(name: "Sports Bike", imageName: "SportsBike"),
        .init(name: "SUV", imageName: "SUV"),
        .init(name: "Trailer", imageName: "Trailer")
    ]
    let selectionFeedback = UISelectionFeedbackGenerator()
    
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
                            selectionFeedback.selectionChanged()
                            if selectedCarType == carType.name {
                                selectedCarType = ""
                            } else {
                                selectedCarType = carType.name
                            }
                        } label: {
                            VStack(spacing: ScaleUtility.scaledSpacing(5)) {
                                ZStack {
                                    Image(isSelected ? .carStroke2 : .carStroke1)
                                        .resizable()
                                        .frame(width: ScaleUtility.scaledValue(100), height: ScaleUtility.scaledValue(100))
                                    
                                    Image(carType.imageName)
                                        .resizable()
                                        .frame(width: ScaleUtility.scaledValue(90), height: ScaleUtility.scaledValue(90))
                                        .clipShape(Circle())
                                }
                                
                                Text(carType.name)
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
