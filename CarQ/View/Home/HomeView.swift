//
//  HomeView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 08/09/25.
//

import Foundation
import SwiftUI

struct HomeView: View {
    @Binding var isCreateScreen: Bool
    @EnvironmentObject var purchaseManager: PurchaseManager
    @EnvironmentObject var timerManager: TimerManager
    @EnvironmentObject var remoteConfigManager: RemoteConfigManager
    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        VStack(spacing: ScaleUtility.scaledSpacing(0)) {
            
            TopView(title: "CarQ")
                .padding(.top, ScaleUtility.scaledSpacing(9))
            
            ScrollView(showsIndicators: false) {
                
                Spacer()
                    .frame(height: ScaleUtility.scaledValue(25))
                
                if remoteConfigManager.giftAfterOnBoarding {
                    if !timerManager.isExpired && !purchaseManager.hasPro && remoteConfigManager.showLifeTimeBannerAtHome {
                        LifeTimeGiftOfferBannerView()
                        
                        Spacer()
                            .frame(height: isIPad ? ScaleUtility.scaledValue(25) : ScaleUtility.scaledValue(15))
                        
                    }
                }
      
                Button(action: {
                    impactFeedback.impactOccurred()
                    isCreateScreen = true
                }) {
                    Image(.createIcon)
                        .resizable()
                        .frame(width: isIPad ? ScaleUtility.scaledValue(715) :  ScaleUtility.scaledValue(345),
                               height: isIPad ?  ScaleUtility.scaledValue(200) : ScaleUtility.scaledValue(150))
                }
                
                Spacer()
                    .frame(height: ScaleUtility.scaledValue(20))

            ToolsView()
            
            Spacer()
                .frame(height: isIPad ? ScaleUtility.scaledValue(200) : ScaleUtility.scaledValue(150))
            
        }
        .background(Color.secondaryApp.edgesIgnoringSafeArea(.all))
        
    }
  }
    
}
