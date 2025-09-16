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
    
    var body: some View {
        ZStack {
            if userDefault.hasFinishedOnboarding {
                MainView()
            }
            else {
                PaywallView(closePayAll: {
                    userDefault.hasFinishedOnboarding = true
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
