//
//  TopView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 08/09/25.
//

import Foundation
import SwiftUI

struct TopView: View {
    @EnvironmentObject var purchaseManager: PurchaseManager
    let impactfeedback = UIImpactFeedbackGenerator(style: .heavy)
    @State var isShowPayWall: Bool = false
    var title: String

    var body: some View {
        HStack {
            Text(title)
                .font(FontManager.ChakraPetchSemiBoldFont(size: .scaledFontSize(24)))
                .foregroundColor(Color.primaryApp)
            
            Spacer()
            
            Button {
                impactfeedback.impactOccurred()
                if !purchaseManager.hasPro {
                    isShowPayWall = true
                }
            } label: {
                Image(.crownIcon)
                    .resizable()
                    .frame(width: ScaleUtility.scaledValue(42), height: ScaleUtility.scaledValue(42))
            }
            .opacity(!purchaseManager.hasPro ? 1 : 0)
        }
        .padding(.horizontal, ScaleUtility.scaledSpacing(15))
        .fullScreenCover(isPresented: $isShowPayWall) {
            
            PaywallView(isInternalOpen: true) {
                isShowPayWall = false
            } purchaseCompletSuccessfullyAction: {
                isShowPayWall = false
            }
        }
    }
}
