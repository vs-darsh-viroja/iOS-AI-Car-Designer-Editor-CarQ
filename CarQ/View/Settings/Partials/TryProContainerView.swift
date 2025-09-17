//
//  TryProContainerView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 12/09/25.
//

import Foundation
import SwiftUI

struct TryProContainerView: View {
    @State var isShowPayWall: Bool = false
    let notificationfeedback = UINotificationFeedbackGenerator()
    let impactfeedback = UIImpactFeedbackGenerator(style: .heavy)
    let selectionfeedback = UISelectionFeedbackGenerator()
    @EnvironmentObject var purchaseManager: PurchaseManager
    
    var body: some View {
        Button {
            impactfeedback.impactOccurred()
            if !purchaseManager.hasPro {
                isShowPayWall = true
            }
        } label: {
  
            HStack(spacing: 0) {
                
                VStack(alignment: .leading) {
                    
                    Text("Access All Features")
                        .font(FontManager.ChakraPetchSemiBoldFont(size: .scaledFontSize(18)))
                        .foregroundColor(Color.primaryApp)
                    
                    Text("Upgrade to Pro")
                        .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(16)))
                        .foregroundColor(Color.primaryApp)
                    
                    
                }
                
                Spacer()
                
                Image(.tryPro)
                    .resizable()
                    .frame(width: ScaleUtility.scaledValue(95), height: ScaleUtility.scaledValue(35))
            }
            .frame(maxWidth: .infinity)
            .padding(.leading, ScaleUtility.scaledSpacing(20))
            .padding(.trailing, ScaleUtility.scaledSpacing(15))
            .padding(.vertical, ScaleUtility.scaledSpacing(23))
            .background {
                Image(.settingsBanner)
                    .resizable()
                    .frame(maxWidth: .infinity)
                    .frame(height: ScaleUtility.scaledValue(80))
            }
        }
        .fullScreenCover(isPresented: $isShowPayWall) {
            
            PaywallView(isInternalOpen: true) {
                isShowPayWall = false
            } purchaseCompletSuccessfullyAction: {
                isShowPayWall = false
            }
        }
    }
    
}
