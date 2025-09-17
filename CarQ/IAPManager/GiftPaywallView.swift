//
//  GiftPaywallView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 17/09/25.
//

import Foundation
import SwiftUI

struct GiftPaywallView: View {
  
    @EnvironmentObject var timerManager: TimerManager
    @EnvironmentObject var purchaseManager: PurchaseManager
    @Binding var isCollectGift: Bool
    @State var plan = SubscriptionPlan.yearlygift
    let closeGift: () -> Void
    let giftPurchaseComplete: () -> Void
    let notificationFeedback = UINotificationFeedbackGenerator()
    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    let selectionFeedback = UISelectionFeedbackGenerator()
    
    var body: some View {
        VStack {
            VStack(spacing: isIPad ? ScaleUtility.scaledSpacing(280) : ScaleUtility.scaledSpacing(180)) {
                VStack(spacing: ScaleUtility.scaledSpacing(30)) {
                    
                    VStack(spacing: ScaleUtility.scaledSpacing(9)) {
                        
                        HStack {
                            
                            Spacer()
                            
                            Button {
                                impactFeedback.impactOccurred()
                                closeGift()
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

                       
                        }
                        .padding(.trailing, ScaleUtility.scaledSpacing(20))
                        
                        Text("Collect Gift")
                            .font(FontManager.ChakraPetchBoldFont(size: .scaledFontSize(32)))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.primaryApp.opacity(0.5))
                            .frame(maxWidth: .infinity, alignment: .top)
                    }
                    
                    if let product = purchaseManager.products.first(where: { $0.id == SubscriptionPlan.yearlygift.productId }),
                       let lifetimePlan = purchaseManager.products.first(where: { $0.id == SubscriptionPlan.yearly.productId }) {
                        
                        let discountPrice = product.displayPrice
                        let originalPrice = lifetimePlan.displayPrice
                        
                        //Extract numerical value from the prices
                        let discountedPriceValue = Double(discountPrice.replacingOccurrences(of: "[^0-9.]", with: "", options: .regularExpression)) ?? 0
                        let originalPriceValue = Double(originalPrice.replacingOccurrences(of: "[^0-9.]", with: "", options: .regularExpression)) ?? 0
                        
                        //calculate the discount percentage
                        let discountPercentage = originalPriceValue > 0 ? round((originalPriceValue - discountedPriceValue) / originalPriceValue * 100) : 0
                            
                        VStack(spacing: ScaleUtility.scaledSpacing(5)) {
                            Text("\(Int(discountPercentage))% OFF")
                                .font(FontManager.ChakraPetchBoldFont(size: .scaledFontSize(60)))
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.primaryApp)
                            
                            Text("on Yearly Plan")
                                .font(FontManager.ChakraPetchMediumFont(size: .scaledFontSize(32)))
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.primaryApp)
                        }
                        
                        
                    }
                }
               
               Image(.giftIcon)
                   .resizable()
                   .frame(width: isIPad ? ScaleUtility.scaledValue(220) : ScaleUtility.scaledValue(150),
                          height: isIPad ? ScaleUtility.scaledValue(220) : ScaleUtility.scaledValue(150))

            }
           .padding(.top, ScaleUtility.scaledSpacing(13))
            
            Spacer()
            
            Button {
                impactFeedback.impactOccurred()
                self.isCollectGift = true
            } label: {
                
                Text("Collect Gift")
                    .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(18)))
                    .foregroundColor(.primaryApp)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
            }
            .background {
                Image(.buttonBg3)
                    .resizable()
                    .frame(width: isIPad ? ScaleUtility.scaledValue(715) : ScaleUtility.scaledValue(345),
                           height: ScaleUtility.scaledValue(60))
                    .overlay {
                            Image(.selectButtonBg)
                                .resizable()
                                .frame(width: isIPad ? ScaleUtility.scaledValue(715) : ScaleUtility.scaledValue(345),
                                       height: ScaleUtility.scaledValue(60))
                    }
            }
            .padding(.bottom, ScaleUtility.scaledSpacing(26))

     
        }
        .background {
            Image(.giftBg)
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(.all)
        }
        .overlay {
            Color.secondaryApp.ignoresSafeArea(.all)
                .opacity(isCollectGift ? 0.75 : 0)
        }
        .sheet(isPresented: $isCollectGift) {
        
        
            GiftPaywallBottomView(
                    closeGiftSheet: {
                        self.isCollectGift = false
//                        AnalyticsManager.shared.log(.giftBottomSheetXClicked)
                    }, purchaseConfirm: giftPurchaseComplete)
                .frame(height: isIPad ? ScaleUtility.scaledValue(655) : ScaleUtility.scaledValue(513) )
                .presentationDetents([.height( isIPad ? ScaleUtility.scaledValue(750) : ScaleUtility.scaledValue(513))])
                .presentationBackground(Color.appGrey)
                .clipShape(RoundedRectangle(cornerRadius: 20))
        
        }

    }
}

