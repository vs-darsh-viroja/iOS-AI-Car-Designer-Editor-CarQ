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
        .init(name: "CyberPunk", imageName: "Cyberpunk"),
        .init(name: "Futuristic", imageName: "Futuristic"),
        .init(name: "Japanese Graphical", imageName: "JapaneseGraphical"),
        .init(name: "Low Rider", imageName: "LowRider"),
        .init(name: "Modern Luxurious", imageName: "ModernLuxurious"),
        .init(name: "Muscle", imageName: "Muscle"),
        .init(name: "Off Road", imageName: "OffRoad"),
        .init(name: "Retro Classic", imageName: "RetroClassic"),
        .init(name: "Stealth", imageName: "Stealth"),
        .init(name: "Street Racer", imageName: "StreetRacer")
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
                            if selectedDesignStyle == designStyle.name {
                                selectedDesignStyle = ""
                            } else {
                                selectedDesignStyle = designStyle.name
                            }
                        } label: {
                            VStack(spacing: ScaleUtility.scaledSpacing(5)) {
                                ZStack {
                                    Image(isSelected ? .carStroke2 : .carStroke1)
                                        .resizable()
                                        .frame(width: ScaleUtility.scaledValue(100), height: ScaleUtility.scaledValue(100))
                                    
                                    
                                    Image(designStyle.imageName)
                                        .resizable()
                                        .frame(width: ScaleUtility.scaledValue(90), height: ScaleUtility.scaledValue(90))
                                        .clipShape(Circle())
                                }
                                
                                Text(designStyle.name)
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
