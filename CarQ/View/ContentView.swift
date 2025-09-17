//
//  ContentView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 06/09/25.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var purchaseManager: PurchaseManager
    @EnvironmentObject var userDefault: UserSettings
    @EnvironmentObject var remoteConfigManager: RemoteConfigManager
    @EnvironmentObject var timerManager: TimerManager
    @State var isCollectGift: Bool = false
    
    var body: some View {
        ZStack {
            if userDefault.hasFinishedOnboarding {
                MainView()
            }
            else if userDefault.hasShownGiftPaywall  {
                GiftPaywallView(isCollectGift: $isCollectGift) {
                    userDefault.hasFinishedOnboarding = true
                } giftPurchaseComplete: {
                    userDefault.hasFinishedOnboarding = true
                }
            }
            else {
                PaywallView(closePayAll: {
                    if purchaseManager.hasPro || !remoteConfigManager.giftAfterOnBoarding {
                        userDefault.hasFinishedOnboarding = true
                    }
                    else {
                        userDefault.hasShownGiftPaywall = true
                    }
                }, purchaseCompletSuccessfullyAction: {
                    userDefault.hasFinishedOnboarding = true 
                })
            }
        }
        .onAppear {
            remoteConfigManager.fetchConfig { success in
                if success {
                    print("RemoteConfigManager initialized and data loaded successfully")
                } else {
                    print("RemoteConfigManager failed to load initial data")
                }
            }
            timerManager.setupCountdown()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            Task {
                await purchaseManager.updatePurchaseProducts()
            }
        }
    }
}

#Preview {
    ContentView()
}
