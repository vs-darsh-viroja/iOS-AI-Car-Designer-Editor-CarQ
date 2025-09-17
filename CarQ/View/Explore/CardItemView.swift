//
//  CardItemView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 17/09/25.
//

import Foundation
import SwiftUI

struct CardItemView: View {
    let card: ExploreCard
    let onTap: () -> Void
    
    var body: some View {
        VStack {
            Image(card.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: ScaleUtility.scaledValue(165),
                       height: ScaleUtility.scaledValue(170))
                .clipped()
                .overlay {
                    Image(.cardBg)
                        .resizable()
                        .frame(width: ScaleUtility.scaledValue(166.00098),
                               height: ScaleUtility.scaledValue(172.00098))
                }
        }
        .onTapGesture {
            onTap()
        }
    }
}

