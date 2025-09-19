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
    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
    var body: some View {
   
        Button {
            impactFeedback.impactOccurred()
            onTap()
        } label: {
            Image(card.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: isIPad ? 385 * ipadWidthRatio : ScaleUtility.scaledValue(165),
                       height: isIPad ? 320 * ipadHeightRatio : ScaleUtility.scaledValue(170))
                .clipped()
                .overlay {
                    Image(.cardBg)
                        .resizable()
                        .frame(width: isIPad ? 389 * ipadWidthRatio : ScaleUtility.scaledValue(166.00098),
                               height: isIPad ? 324 * ipadHeightRatio : ScaleUtility.scaledValue(172.00098))
                }
        }

       
    }
}

