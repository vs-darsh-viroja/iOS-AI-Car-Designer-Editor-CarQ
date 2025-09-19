//
//  AppDelegate.swift
//  CarQ
//
//  Created by Purvi Sancheti on 19/09/25.
//

import Foundation
import UIKit
import GoogleMobileAds

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        MobileAds.shared.start()
        return true
    }
}
