//
//  RewardedAdManager.swift
//  CarQ
//
//  Created by Purvi Sancheti on 19/09/25.
//

import Foundation
import Foundation
import GoogleMobileAds

@MainActor
final class RewardedAdManager: NSObject, ObservableObject, FullScreenContentDelegate {
    private let adUnitID: String
    private var rewardedAd: RewardedAd? // On older SDKs, use GADRewardedAd
    @Published var isLoading = false

    init(adUnitID: String) {
        self.adUnitID = adUnitID
        super.init()
    }

    /// Loads a rewarded ad in the background
    func load() async {
        guard !isLoading, rewardedAd == nil else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            rewardedAd = try await RewardedAd.load(with: adUnitID, request: Request())
            rewardedAd?.fullScreenContentDelegate = self
        } catch {
            rewardedAd = nil
            print("Rewarded failed to load: \(error.localizedDescription)")
        }
    }

    /// Shows the ad if ready; otherwise tries to load and then show.
    /// If anything fails, we call `proceedAnyway()`.
    func showOrProceed(
        onReward: @escaping (_ amount: Int) -> Void,
        proceedAnyway: @escaping () -> Void
    ) {
        Task { @MainActor in
            if rewardedAd == nil { await load() }
            guard let ad = rewardedAd else {
                proceedAnyway()
                return
            }
            ad.present(from: nil) { [weak self] in
                guard let self else { return }
                let reward = ad.adReward
                onReward(reward.amount.intValue)
            }
        }
    }

    // MARK: - FullScreenContentDelegate
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        // Clear & optionally preload the next ad.
        rewardedAd = nil
        Task { await load() }
    }

    func ad(
        _ ad: FullScreenPresentingAd,
        didFailToPresentFullScreenContentWithError error: Error
    ) {
        print("Failed to present rewarded: \(error.localizedDescription)")
        rewardedAd = nil
    }
}

