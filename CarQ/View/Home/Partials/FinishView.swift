//
//  FinishView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 12/09/25.
//


import Foundation
import SwiftUI

struct FinishView: View {
    @Binding var selectedFinish: String
    
    struct FinishType {
        let name: String
        let imageName: String
    }
    
    private let finishTypes: [FinishType] = [
        .init(name: "High Gloss", imageName: "dummyCarImage"),
        .init(name: "Semi-Gloss", imageName: "dummyCarImage"),
        .init(name: "Satin", imageName: "dummyCarImage"),
        .init(name: "Matte", imageName: "dummyCarImage"),
        .init(name: "Flat", imageName: "dummyCarImage"),
        .init(name: "Textured", imageName: "dummyCarImage"),
        .init(name: "Brushed", imageName: "dummyCarImage"),
        .init(name: "Hammered", imageName: "dummyCarImage"),
        .init(name: "Crackle", imageName: "dummyCarImage"),
        .init(name: "Distressed", imageName: "dummyCarImage")
    ]
    
    var body: some View {
        VStack(spacing: ScaleUtility.scaledSpacing(13)) {
            Text("Finish")
                .font(FontManager.ChakraPetchSemiBoldFont(size: .scaledFontSize(18)))
                .multilineTextAlignment(.center)
                .foregroundColor(Color.primaryApp)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, ScaleUtility.scaledSpacing(15))
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: ScaleUtility.scaledSpacing(11)) {
                    ForEach(finishTypes.indices, id: \.self) { index in
                        let finishType = finishTypes[index]
                        let isSelected = selectedFinish == finishType.name
                        
                        Button {
                            selectedFinish = finishType.name
                        } label: {
                            VStack {
                                ZStack {
                                    Image(isSelected ? .carStroke2 : .carStroke1)
                                        .resizable()
                                        .frame(width: ScaleUtility.scaledValue(100), height: ScaleUtility.scaledValue(100))
                                    
                                    Image(finishType.imageName)
                                        .resizable()
                                        .frame(width: ScaleUtility.scaledValue(90), height: ScaleUtility.scaledValue(90))
                                }
                                
                                Text(finishType.name)
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
