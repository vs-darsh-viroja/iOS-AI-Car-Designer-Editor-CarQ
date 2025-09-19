//
//  AppOpenAdManager.swift
//  CarQ
//
//  Created by Purvi Sancheti on 19/09/25.
//



import Foundation
import GoogleMobileAds

final class AppOpenAdManager: NSObject, FullScreenContentDelegate, ObservableObject {
    private var appOpenAd: AppOpenAd?

    @Published var isAppload: Bool = false

    func loadAd() {
        let request = Request()
        AppOpenAd.load(with: AdConstants.appOpenTestID, request: Request()) { add, error in
            if let error = error {
                print("Failed to load app open ad: \(error.localizedDescription)")
                return
            }
            self.appOpenAd = add
            self.isAppload = true
            self.appOpenAd?.fullScreenContentDelegate = self
            print("App open ad loaded successfully.")

        }
    }

    func showAdIfAvailable() {
        guard let ad = appOpenAd,
              let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
            loadAd()
            return
        }
        ad.present(from: rootViewController)
    }

    // MARK: - GADFullScreenContentDelegate

    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("App open ad dismissed.")
        loadAd()
    }

    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Failed to present app open ad: \(error.localizedDescription)")
        loadAd()
    }

}
