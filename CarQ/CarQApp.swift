//
//  CarQApp.swift
//  CarQ
//
//  Created by Purvi Sancheti on 06/09/25.
//

import SwiftUI
import Firebase


@main
struct CarQApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var remoteConfigManager = RemoteConfigManager()
    @StateObject private var userSettings = UserSettings()
    @StateObject private var purchaseManager = PurchaseManager()
    @StateObject private var timerManager = TimerManager()
    
    init() {
          FirebaseApp.configure()
//          MobileAds.shared.start(completionHandler: nil)
      }
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(timerManager)
                .environmentObject(remoteConfigManager)
                .environmentObject(userSettings)
                .environmentObject(purchaseManager)
        }
    }
}
