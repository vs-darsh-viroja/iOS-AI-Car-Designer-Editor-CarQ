//
//  GiftPaywallBottmView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 17/09/25.
//

import Foundation
import SwiftUI

struct GiftPaywallBottomView: View {
    
    @EnvironmentObject var purchaseManager: PurchaseManager
    @EnvironmentObject var timerManager: TimerManager
    let closeGiftSheet: () -> Void
    let purchaseConfirm: () -> Void
    
    let notificationfeedback = UINotificationFeedbackGenerator()
    let impactfeedback = UIImpactFeedbackGenerator(style: .medium)
    let selectionfeedback = UISelectionFeedbackGenerator()
 
    var body: some View {
        
        if let product = purchaseManager.products.first(where: { $0.id == SubscriptionPlan.yearlygift.productId }),
           let lifetimePlan = purchaseManager.products.first(where: { $0.id == SubscriptionPlan.yearly.productId }) {
            
            let discountPrice = product.displayPrice
            let originalPrice = lifetimePlan.displayPrice
            
            //Extract numerical value from the prices
            let discountedPriceValue = Double(discountPrice.replacingOccurrences(of: "[^0-9.]", with: "", options: .regularExpression)) ?? 0
            let originalPriceValue = Double(originalPrice.replacingOccurrences(of: "[^0-9.]", with: "", options: .regularExpression)) ?? 0
            
            //calculate the discount percentage
            let discountPercentage = originalPriceValue > 0 ? round((originalPriceValue - discountedPriceValue) / originalPriceValue * 100) : 0
            ZStack(alignment: .topTrailing) {
 
                Image(.giftSheetBg)
                    .resizable()
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
          
                VStack(spacing: 0) {
                    
                    VStack(spacing: ScaleUtility.scaledSpacing(35)) {
                        
                        VStack(spacing: ScaleUtility.scaledSpacing(10)) {
                            
                            if discountPercentage == 100 {
                                Text("Free")
                                    .font(FontManager.ChakraPetchBoldFont(size: .scaledFontSize(52)))
                                    .foregroundColor(Color.primaryApp)
                            } else {
                                Text("\(Int(discountPercentage))% OFF")
                                    .font(FontManager.ChakraPetchBoldFont(size: .scaledFontSize(52)))
                                    .foregroundColor(Color.primaryApp)
                            }
                            
                            VStack(spacing: ScaleUtility.scaledSpacing(25)) {
                                
                                Text("On Yearly plan")
                                    .font(FontManager.ChakraPetchMediumFont(size: .scaledFontSize(24)))
                                    .foregroundStyle(Color.primaryApp)
                                
                                Text("Once you close this offer, it’s gone")
                                    .font(FontManager.ChakraPetchMediumFont(size: .scaledFontSize(18)))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.primaryApp.opacity(0.5))
                                
                                HStack(spacing: ScaleUtility.scaledValue(6)) {
                                    if timerManager.isExpired {
                                        Text("Offer expired")
                                            .font(FontManager.ChakraPetchBoldFont(size: .scaledFontSize(16)))
                                            .foregroundColor(Color.primaryApp)
                                        
                                    }
                                    
                                    Text("Expires in")
                                        .font(FontManager.ChakraPetchBoldFont(size: .scaledFontSize(24)))
                                        .foregroundColor(Color.primaryApp.opacity(0.4))
                                    
                                    
                                    Text("\(timerManager.hours):\(String(format: "%02d", timerManager.minutes)):\(String(format: "%02d", timerManager.seconds))")
                                        .font(FontManager.ChakraPetchBoldFont(size: .scaledFontSize(24)))
                                        .foregroundColor(Color.appLightRed)
                                    
                                    
                                }
                                
                            }
                        }
                        .padding(.top,ScaleUtility.scaledSpacing(24))
                        
                        ZStack {
                            
                            Image(.giftPlanBg)
                                .resizable()
                                .frame(maxWidth: .infinity)
                                .frame(height: isIPad ? 219 * ipadHeightRatio : ScaleUtility.scaledValue(139))
                            
                            ZStack(alignment: .topTrailing) {
                                
                                VStack(alignment: .leading,spacing: ScaleUtility.scaledSpacing(21)) {
                                    Text("Limited time offer")
                                        .font(FontManager.ChakraPetchMediumFont(size: .scaledFontSize(18)))
                                        .foregroundColor(Color.primaryApp)
                                        .offset(y: ScaleUtility.scaledSpacing(10))
                                    
                                    VStack(spacing: ScaleUtility.scaledSpacing(15)) {
                                        
                                        Text("Just \(discountPrice)")
                                            .font(FontManager.ChakraPetchSemiBoldFont(size: .scaledFontSize(40)))
                                            .foregroundColor(Color.primaryApp)
                                            .frame(maxWidth: .infinity, alignment: .topLeading)
                                        
                                        Text("for the first month, then only $69.99 / year")
                                            .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(14)))
                                            .foregroundColor(Color.primaryApp.opacity(0.5))
                                            .frame(maxWidth: .infinity, alignment: .topLeading)
                                            .offset(y: ScaleUtility.scaledSpacing(-10))
                                    }
                                    
                                    
                                }
                                .offset(x: ScaleUtility.scaledSpacing(15))
                                
                                
                                
                                Image(.tagIcon)
                                    .resizable()
                                    .frame(width: isIPad ? 123.71429 * ipadWidthRatio : ScaleUtility.scaledValue(83.71429),
                                           height:  isIPad ? 123.71429 * ipadHeightRatio : ScaleUtility.scaledValue(83.71429))
                                    .padding(.top, ScaleUtility.scaledSpacing(7))
                                    .offset(x: ScaleUtility.scaledSpacing(-5.92))
                            }
                            
                        }
                        .overlay {
                            Image(.giftPlanOverlay)
                                .resizable()
                                .frame(maxWidth: .infinity)
                                .frame(height: isIPad ? 219 * ipadHeightRatio : ScaleUtility.scaledValue(139))
                        }
                        .padding(.horizontal, ScaleUtility.scaledSpacing(22))
                        
                        
                        VStack(spacing: 0) {
                            Button {
                                impactfeedback.impactOccurred()
                                Task {
                                    
                                    do {
                                        try await purchaseManager.purchase(product)
                                        if purchaseManager.hasPro {
                                            purchaseConfirm()
                                            notificationfeedback.notificationOccurred(.success)
                                            //                                    AnalyticsManager.shared.log(.giftScreenPlanPurchase)
                                        }
                                    } catch {
                                        notificationfeedback.notificationOccurred(.error)
                                        print("Purchase failed: \(error)")
                                        purchaseManager.isInProgress = false
                                        purchaseManager.alertMessage = "Purchase Failed! Please try again or check your payment method."
                                        purchaseManager.showAlert = true
                                    }
                                }
                            } label: {
                                
                                Text("Claim Now")
                                    .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(18)))
                                    .foregroundColor(.primaryApp)
                                    .multilineTextAlignment(.center)
                                    .frame(maxWidth: .infinity)
                            }
                            .background {
                                Image(.buttonBg3)
                                    .resizable()
                                    .frame(width: isIPad ? 545 * ipadWidthRatio  : ScaleUtility.scaledValue(345),
                                           height: ScaleUtility.scaledValue(60))
                                    .overlay {
                                        Image(.selectButtonBg)
                                            .resizable()
                                            .frame(width: isIPad ? 545 * ipadWidthRatio : ScaleUtility.scaledValue(345),
                                                   height: ScaleUtility.scaledValue(60))
                                    }
                            }
                            .padding(.top, ScaleUtility.scaledSpacing(15))
                        }
                        
                        
                    }
       
           
              
                    
                }
                .alert(isPresented: $purchaseManager.showAlert) {
                    Alert(
                        title: Text("Error"),
                        message: Text(purchaseManager.alertMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }
                
                Button {
                    impactfeedback.impactOccurred()
                    closeGiftSheet()
                } label: {
                    Image(.crossIcon3)
                        .resizable()
                        .frame(width: ScaleUtility.scaledValue(20), height: ScaleUtility.scaledValue(20))
                        .padding(.all,ScaleUtility.scaledSpacing(4))
                        .background {
                            Circle()
                                .fill(Color.primaryApp.opacity(0.1))
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .inset(by: -0.5)
                                .stroke(.primaryApp.opacity(0.2), lineWidth: 1)
                        )
                }
                .padding(.top, ScaleUtility.scaledSpacing(20))
                .padding(.trailing, ScaleUtility.scaledSpacing(20))
            }
            .ignoresSafeArea(.keyboard)
        }
    }
}
