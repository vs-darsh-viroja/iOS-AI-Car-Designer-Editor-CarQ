//
//  LifeTimeGiftOfferBannerView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 17/09/25.
//

import Foundation
import SwiftUI


struct LifeTimeGiftOfferBannerView: View {
    
    @EnvironmentObject var timerManager: TimerManager
    @EnvironmentObject var purchaseManager: PurchaseManager
    @EnvironmentObject var remoteConfigManager: RemoteConfigManager
    @EnvironmentObject var userDefaultSetting: UserSettings
    @Environment(\.colorScheme) var colorScheme
    
    let notificationfeedback = UINotificationFeedbackGenerator()
    let impactfeedback = UIImpactFeedbackGenerator(style: .medium)
    let selectionfeedback = UISelectionFeedbackGenerator()
    
    var body: some View {
        
        if let product = purchaseManager.products.first(where: { $0.id == SubscriptionPlan.yearlygift.productId }),
           let lifetimePlan = purchaseManager.products.first(where: { $0.id == SubscriptionPlan.yearly.productId }) {
            
            let discountPrice = product.displayPrice
            let originalPrice = lifetimePlan.displayPrice
            
            let discountedPriceValue = Double(discountPrice.replacingOccurrences(of: "[^0-9.]", with: "", options: .regularExpression)) ?? 0
            let originalPriceValue = Double(originalPrice.replacingOccurrences(of: "[^0-9.]", with: "", options: .regularExpression)) ?? 0
            
            let discountPercentage = originalPriceValue > 0 ? round((originalPriceValue - discountedPriceValue) / originalPriceValue * 100) : 0
            
            ZStack(alignment: .trailing) {
                
                
                
                HStack(spacing: 0) {
                    
                    VStack(alignment: .leading,spacing: ScaleUtility.scaledSpacing(5)) {
                        Text("\(Int(discountPercentage))% off")
                            .font(FontManager.ChakraPetchSemiBoldFont(size: .scaledFontSize(40)))
                            .foregroundColor(Color.primaryApp)
                        
                        Text("on Yearly plan")
                            .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(20)))
                            .foregroundColor(Color.primaryApp)
                            .offset(x:ScaleUtility.scaledSpacing(2),
                                    y: isIPad ? ScaleUtility.scaledSpacing(-9) : ScaleUtility.scaledSpacing(-3))
                    }
                    .padding(.leading, isIPad ? ScaleUtility.scaledSpacing(30) :  ScaleUtility.scaledSpacing(20))
                    
                    Spacer()
              
                }
                
                VStack(spacing:  ScaleUtility.scaledSpacing(0)) {
                    Text("\(timerManager.hours) : \(String(format: "%02d", timerManager.minutes)) : \(String(format: "%02d", timerManager.seconds))")
                        .font(FontManager.ChakraPetchMediumFont(size: .scaledFontSize(14)))
                        .foregroundColor(Color.primaryApp)
                        .frame(width: isIPad ? ScaleUtility.scaledValue(107) : 77 * widthRatio, height: ScaleUtility.scaledValue(14))
                        .padding(.vertical, ScaleUtility.scaledValue(10))
                        .padding(.horizontal, ScaleUtility.scaledValue(13))
                        .background {
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        stops: [
                                            Gradient.Stop(color: Color(red: 0, green: 0.49, blue: 0.96), location: 0.00),
                                            Gradient.Stop(color: Color(red: 0, green: 0.21, blue: 0.41), location: 1.00),
                                        ],
                                        startPoint: UnitPoint(x: 0, y: 0.5),
                                        endPoint: UnitPoint(x: 1, y: 0.5)
                                    )
                                )
                            
                        }
                        .padding(.trailing, isIPad ? ScaleUtility.scaledSpacing(33) : ScaleUtility.scaledSpacing(13))
                        .padding(.bottom, isIPad ? ScaleUtility.scaledSpacing(15) : 0 )
                        .opacity(remoteConfigManager.showLifeTimeBannerAtHome ? 1 : 0)
                    
                    Spacer()
                    
                    
                    Button {
                        print("clicked")
                        impactfeedback.impactOccurred()
                        Task {
                            do {
                                try await purchaseManager.purchase(product)
    //                                AnalyticsManager.shared.log(.giftBannerPlanPurchase)
                                
                            } catch {
                                print("Purchase failed: \(error)")
                                purchaseManager.isInProgress = false
                                purchaseManager.alertMessage = "Purchase Failed! Please try again or check your payment method."
                                purchaseManager.showAlert = true
                            }
                        }
                    }
                    label: {
                        RoundedRectangle(cornerRadius: 6)
                            .foregroundColor(Color.clear)
                            .background {
                                Image(.giftBannerPlanBg)
                                    .resizable()
                                    .frame(width: isIPad ? 187 * ipadWidthRatio : ScaleUtility.scaledValue(127),
                                           height: isIPad ? 59 * ipadHeightRatio : ScaleUtility.scaledValue(39))
                            }
                            .frame(width: isIPad ? 187 * ipadWidthRatio : ScaleUtility.scaledValue(127),
                                   height: isIPad ? 59 * ipadHeightRatio : ScaleUtility.scaledValue(39))
                            .overlay {
                                if purchaseManager.isInProgress {
                                    ProgressView()
                                        .tint(Color.primaryApp)
                                }
                                else{
                                    HStack(spacing: 0) {
                                        Text(originalPrice)
                                            .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(12)))
                                            .foregroundColor(Color.secondaryApp.opacity(0.5))
                                            .strikethrough()
                                        
                                        Text(discountPrice)
                                            .font(FontManager.ChakraPetchSemiBoldFont(size: .scaledFontSize(18)))
                                            .foregroundColor(Color.secondaryApp)
                                            .padding(.leading, ScaleUtility.scaledSpacing(5))
                                        
                                        Image(.leftArrowIcon)
                                            .resizable()
                                            .frame(width: ScaleUtility.scaledValue(12), height: ScaleUtility.scaledValue(12))
                                            .padding(.leading, ScaleUtility.scaledSpacing(5))
                                    }
                                }
                            }
                            .zIndex(1)
                        
                    }
                    .zIndex(1)
                    .disabled(purchaseManager.isInProgress)
                    .padding(.bottom, isIPad ?  ScaleUtility.scaledSpacing(10)  : ScaleUtility.scaledSpacing(15))
                    .padding(.trailing, isIPad ?  ScaleUtility.scaledSpacing(26) : ScaleUtility.scaledSpacing(16))
                    
                }
      
            }
            .alert(isPresented: $purchaseManager.showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(purchaseManager.alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            .frame(maxWidth:.infinity)
            .frame(height: isIPad ?  ScaleUtility.scaledValue(121) * ipadHeightRatio  : ScaleUtility.scaledValue(105) )
            .background {
                Image(.giftBannerBg)
                    .resizable()
                    .frame(maxWidth:.infinity)
                    .frame(height: isIPad ? 150 * ipadHeightRatio : ScaleUtility.scaledValue(105))
            }
            .padding(.horizontal, remoteConfigManager.showLifeTimeBannerAtHome ? ScaleUtility.scaledSpacing(15) : 0)
           
        }
    }
}

