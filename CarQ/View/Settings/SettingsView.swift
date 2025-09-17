//
//  SettingsView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 08/09/25.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    @Environment(\.openURL) var openURL
    @EnvironmentObject var  userSettings: UserSettings
    @EnvironmentObject var purchaseManager: PurchaseManager
    @EnvironmentObject var timerManager: TimerManager
    @EnvironmentObject var remoteConfigManager: RemoteConfigManager
    
    let notificationfeedback = UINotificationFeedbackGenerator()
    let impactfeedback = UIImpactFeedbackGenerator(style: .medium)
    let selectionfeedback = UISelectionFeedbackGenerator()
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: ScaleUtility.scaledSpacing(25)) {
                Text("Settings")
                    .font(FontManager.ChakraPetchSemiBoldFont(size: .scaledFontSize(24)))
                    .foregroundColor(Color.primaryApp)
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .padding(.top, ScaleUtility.scaledSpacing(15))
                    
                VStack(spacing: 0) {
                    
                    VStack(spacing: ScaleUtility.scaledSpacing(15)) {
                        if remoteConfigManager.giftAfterOnBoarding {
                            if !timerManager.isExpired && !purchaseManager.hasPro && !remoteConfigManager.showLifeTimeBannerAtHome {
                                LifeTimeGiftOfferBannerView()
                                
                            }
                        }
                        
                        TryProContainerView()
                    }
                    
                    ScrollView(showsIndicators: false) {
                        
                        Spacer()
                            .frame(height: ScaleUtility.scaledValue(15))
                        
                        VStack(spacing: ScaleUtility.scaledSpacing(10)) {
                            // MARK: - First Card
                            
                            HStack(spacing: 0) {
                                CommonRowView(rowText: "User ID", rowImage: "userIDIcon")
                                
                                Spacer()
                                
                                Text("XR" + userSettings.userId + "P")
                                    .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(12)))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color.primaryApp.opacity(0.5))
                                
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.leading, ScaleUtility.scaledSpacing(15))
                            .padding(.trailing, ScaleUtility.scaledSpacing(20))
                            .padding(.top, ScaleUtility.scaledSpacing(19))
                            .padding(.bottom, ScaleUtility.scaledSpacing(17))
                            .background {
                                Image(.settingsBg1)
                                    .resizable()
                                    .frame(height: ScaleUtility.scaledValue(54))
                                    .frame(maxWidth: .infinity)
                            }
                            
                            // MARK: - Second Card
                            
                            VStack(spacing: ScaleUtility.scaledSpacing(15)) {
                                
                                Button {
                                    impactfeedback.impactOccurred()
                                    if let url = URL(string: AppConstant.ratingPopupURL) {
                                        openURL(url)
                                    }
                                } label: {
                                    CommonRowView(rowText: "Rate Us", rowImage: "userIDIcon")
                                        .padding(.horizontal, ScaleUtility.scaledSpacing(15))
                                }
                                
                                Rectangle()
                                    .foregroundColor(Color.primaryApp.opacity(0.1))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: ScaleUtility.scaledValue(1.5))
                                
                                ShareLink(item: URL(string: AppConstant.shareAppIDURL)!)
                                {
                                    CommonRowView(rowText: "Share App", rowImage: "shareIcon2")
                                        .padding(.horizontal, ScaleUtility.scaledSpacing(15))
                                }
                                
                                Rectangle()
                                    .foregroundColor(Color.primaryApp.opacity(0.1))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: ScaleUtility.scaledValue(1.5))
                                
                                Button(action: {
                                    impactfeedback.impactOccurred()
                                    let url = URL(string: AppConstant.aboutAppURL)!
                                    openURL(url)
                                }) {
                                    HStack {
                                        
                                        CommonRowView(rowText: "About App", rowImage: "aboutIcon")
                                        
                                        Spacer()
                                        
                                        Text("Version \(Bundle.appVersion)")
                                            .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(12)))
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(Color.primaryApp.opacity(0.5))
                                        
                                    }
                                }
                                .padding(.horizontal, ScaleUtility.scaledSpacing(15))
                            }
                            .frame(maxWidth: .infinity,alignment: .leading)
                            .padding(.vertical, ScaleUtility.scaledSpacing(15))
                            .background {
                                Image(.settingsBg2)
                                    .resizable()
                                    .frame(height: isIPad ? 216 * ipadHeightRatio : ScaleUtility.scaledValue(156))
                                    .frame(maxWidth: .infinity)
                                
                            }
                            
                            // MARK: - Third Card
                            
                            VStack(spacing: ScaleUtility.scaledSpacing(15)) {
                                
                                Button(action: {
                                    impactfeedback.impactOccurred()
                                    let url = URL(string: AppConstant.contactUSURL)!
                                    openURL(url)
                                }) {
                                    CommonRowView(rowText: "Contact Us", rowImage: "contactUsIcon")
                                        .padding(.horizontal, ScaleUtility.scaledSpacing(15))
                                }
                                
                                
                                Rectangle()
                                    .foregroundColor(Color.primaryApp.opacity(0.1))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: ScaleUtility.scaledValue(1.5))
                                
                                Button(action: {
                                    impactfeedback.impactOccurred()
                                    let url = URL(string: AppConstant.supportURL)!
                                    openURL(url)
                                }) {
                                    CommonRowView(rowText: "Support", rowImage: "supportIcon")
                                        .padding(.horizontal, ScaleUtility.scaledSpacing(15))
                                }
                                
                                Rectangle()
                                    .foregroundColor(Color.primaryApp.opacity(0.1))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: ScaleUtility.scaledValue(1.5))
                                
                                Button(action: {
                                    impactfeedback.impactOccurred()
                                    let url = URL(string: AppConstant.privacyURL)!
                                    openURL(url)
                                }) {
                                    CommonRowView(rowText: "Privacy Policies", rowImage: "privacyIcon")
                                        .padding(.horizontal, ScaleUtility.scaledSpacing(15))
                                }
                                
                                Rectangle()
                                    .foregroundColor(Color.primaryApp.opacity(0.1))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: ScaleUtility.scaledValue(1.5))
                                
                                Button(action: {
                                    impactfeedback.impactOccurred()
                                    let url = URL(string: AppConstant.termsAndConditionURL)!
                                    openURL(url)
                                }) {
                                    CommonRowView(rowText: "Terms & Conditions", rowImage: "termsIcon")
                                        .padding(.horizontal, ScaleUtility.scaledSpacing(15))
                                }
                            }
                            .frame(maxWidth: .infinity,alignment: .leading)
                            .padding(.vertical, ScaleUtility.scaledSpacing(15))
                            .background {
                                Image(.settingsBg3)
                                    .resizable()
                                    .frame(height: isIPad ? ScaleUtility.scaledValue(228) : ScaleUtility.scaledValue(208))
                                    .frame(maxWidth: .infinity)
                                
                            }
                            .offset(y: isIPad ? ScaleUtility.scaledSpacing(5) : 0)
                        }
                    }
                    
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, ScaleUtility.scaledSpacing(15))
        
    }
}


extension Bundle {
    static var appVersion: String {
        (main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "-"
    }
    static var buildNumber: String {
        (main.infoDictionary?["CFBundleVersion"] as? String) ?? "-"
    }
}
