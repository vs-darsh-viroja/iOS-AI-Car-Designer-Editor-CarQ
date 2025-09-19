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
        .init(name: "Chrome", imageName: "Chrome"),
        .init(name: "Glossy", imageName: "Glossy"),
        .init(name: "Matte", imageName: "Matte"),
        .init(name: "Metallic", imageName: "Metallic"),
        .init(name: "Satin", imageName: "Satin"),
    ]

    let selectionFeedback = UISelectionFeedbackGenerator()
    
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
                            selectionFeedback.selectionChanged()
                            if selectedFinish == finishType.name {
                                selectedFinish = ""
                            } else {
                                selectedFinish = finishType.name
                            }
                         
                        } label: {
                            VStack {
                                ZStack {
                                    Image(isSelected ? .carStroke2 : .carStroke1)
                                        .resizable()
                                        .frame(width: ScaleUtility.scaledValue(100), height: ScaleUtility.scaledValue(100))
                                    
                                    Image(finishType.imageName)
                                        .resizable()
                                        .frame(width: ScaleUtility.scaledValue(90), height: ScaleUtility.scaledValue(90))
                                        .clipShape(Circle())
                                }
                                
                                Text(finishType.name)
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
