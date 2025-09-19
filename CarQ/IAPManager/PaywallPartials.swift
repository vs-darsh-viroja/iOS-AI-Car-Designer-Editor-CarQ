//
//  PaywallPartials.swift
//  CarQ
//
//  Created by Purvi Sancheti on 16/09/25.
//

import Foundation
import SwiftUI
import StoreKit

struct PaywallHeaderView: View {
    
    @Binding var isShowCloseButton: Bool
    @Binding var isDisable: Bool
    let restoreAction: () -> Void
    let closeAction: () -> Void
    var isInternalOpen: Bool = false
    
    var delayCloseButton: Bool = false
    var delaySeconds: Double
    
    let impactfeedback = UIImpactFeedbackGenerator(style: .medium)
    
    @State private var isRestorePressed = false
    @State private var isCrossPressed = false
    
    @State private var isCountdownFinished = false   // NEW
    @State private var hasStartedCountdown = false   // NEW
    
    @State private var closeProgress: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .top) {
      
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height: isIPad ? ScaleUtility.scaledValue(380) :   ScaleUtility.scaledValue(220))
                .foregroundColor(Color.clear)
                .background {
                    Image(.paywallCar)
                        .resizable()
                        .aspectRatio(contentMode: isIPad ? .fill : .fit)
                        .frame(height: isIPad ? ScaleUtility.scaledValue(400) :   ScaleUtility.scaledValue(250))
                        .frame(maxWidth: .infinity)
                        .scaleEffect(1.1)
                        .offset(y: isIPad ?  ScaleUtility.scaledSpacing(0) : ScaleUtility.scaledSpacing(20))
                        .clipped()
                        .overlay {
                            Image(.paywallCarOverlay)
                                .resizable()
                                .frame(height: isIPad ? ScaleUtility.scaledValue(401) :   ScaleUtility.scaledValue(254))
                                .frame(maxWidth: .infinity)
                        }
                }
            
       
            
            
            HStack(spacing: 0) {
                Button {
                    impactfeedback.impactOccurred()
                    restoreAction()
                } label: {
                    Text("Restore")
                        .font(FontManager.ChakraPetchMediumFont(size: .scaledFontSize(10)))
                        .foregroundStyle(.primaryApp)
                        .padding(.horizontal, ScaleUtility.scaledSpacing(12))
                        .padding(.vertical, ScaleUtility.scaledSpacing(10))
                        .background(Color.secondaryApp.opacity(0.5))
                        .cornerRadius(500)
                        .overlay(
                            RoundedRectangle(cornerRadius: 500)
                                .stroke(Color.primaryApp.opacity(0.1), lineWidth: 1)
                        )
                    
                }
                .buttonStyle(PlainButtonStyle())
                .scaleEffect(isRestorePressed ? 0.95 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isRestorePressed)
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            withAnimation {
                                isRestorePressed = true
                            }
                        }
                        .onEnded { _ in
                            withAnimation {
                                isRestorePressed = false
                            }
                        }
                )
   
          
                
                Spacer()
                
                Button {
                    impactfeedback.impactOccurred()
                    closeAction()
                } label: {
                    Image(.crossIcon4)
                        .resizable()
                        .frame(width: ScaleUtility.scaledValue(28), height: ScaleUtility.scaledValue(28))
//                        .padding(.all,ScaleUtility.scaledSpacing(4))
//                        .background {
//                            Circle()
//                                .fill(.primaryApp.opacity(0.1))
//                          }
                        .overlay(
                            ZStack {
                                // Base ring
                                Circle()
                                    .stroke(
                                        delayCloseButton ? Color.secondaryApp.opacity(0.15) : .primaryApp,
                                        lineWidth: 2
                                    )
                                
                                // Animated white progress ring (only when delaying)
                                if delayCloseButton {
                                    Circle()
                                        .trim(from: 0, to: closeProgress)
                                        .stroke(Color.primaryApp, style: StrokeStyle(lineWidth: 2, lineCap: .round))
                                        .rotationEffect(.degrees(-90)) // start at top
                                }
                            }
                        )
                }
                .disabled(isDisable || (delayCloseButton && closeProgress < 1))
                .buttonStyle(PlainButtonStyle())
                .opacity(isShowCloseButton ? 1 : 0)
                .scaleEffect(isCrossPressed ? 0.95 : 1.0)
                .padding(.trailing, ScaleUtility.scaledSpacing(5))
                .disabled(isDisable || (delayCloseButton && !isCountdownFinished)) // CHANGED
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            withAnimation {
                                isCrossPressed = true
                            }
                        }
                        .onEnded { _ in
                            withAnimation {
                                isCrossPressed = false
                            }
                        }
                    
                )
                .onAppear {
                    guard !hasStartedCountdown else { return }  // prevent multiple starts
                    hasStartedCountdown = true

                    if delayCloseButton {
                        isCountdownFinished = false
                        closeProgress = 0

                        // Animate the ring visually
                        withAnimation(.linear(duration: delaySeconds)) {
                            closeProgress = 1
                        }

                        // Flip the gate AFTER the duration
                        DispatchQueue.main.asyncAfter(deadline: .now() + delaySeconds) {
                            withAnimation { isCountdownFinished = true }
                        }
                    } else {
                        closeProgress = 1
                        isCountdownFinished = true
                    }
                }
             
            }
            .frame(height: 24 * heightRatio)
            .disabled(isDisable || (delayCloseButton && closeProgress < 1))
            .padding(.top,ScaleUtility.scaledSpacing(55))
            .padding(.horizontal,ScaleUtility.scaledSpacing(15))
            
        }
        .ignoresSafeArea(.all)
        .onAppear {
            guard !hasStartedCountdown else { return }  // prevent multiple starts
            hasStartedCountdown = true

            if delayCloseButton {
                isCountdownFinished = false
                closeProgress = 0

                // Animate the ring visually
                withAnimation(.linear(duration: delaySeconds)) {
                    closeProgress = 1
                }

                // Flip the gate AFTER the duration
                DispatchQueue.main.asyncAfter(deadline: .now() + delaySeconds) {
                    withAnimation { isCountdownFinished = true }
                }
            } else {
                closeProgress = 1
                isCountdownFinished = true
            }
        }
    }
}


struct PaywallProFeatureView: View {
    var body: some View {
        VStack(spacing: ScaleUtility.scaledSpacing(10)) {
            VStack(spacing: ScaleUtility.scaledSpacing(10)) {
                
                Text("Go CarQ Pro")
                  .font(FontManager.ChakraPetchBoldFont(size: .scaledFontSize(40)))
                  .multilineTextAlignment(.center)
                  .foregroundColor(Color.primaryApp)
           
                
                Text("Unlock Full Garage")
                    .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(18)))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .opacity(0.5)
                
            }
            
            VStack(alignment: .leading,spacing: ScaleUtility.scaledSpacing(10)) {
                ForEach(PremiumFeature.allCases, id: \.title) { feature in
                    HStack(spacing: ScaleUtility.scaledSpacing(9)) {
                        Image(feature.image)
                            .resizable()
                            .frame(width: 24 * widthRatio, height: 24 * heightRatio)
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Text(feature.title)
                                .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(14)))
                                .kerning(0.2)
                                .foregroundStyle(Color.primaryApp)
                  
                        }
                     }
                }
            }
        }
    }
}


struct PaywallPlanView: View {
    
    @EnvironmentObject var remoteConfigManager: RemoteConfigManager
    @EnvironmentObject var purchaseManager: PurchaseManager
    @Binding var selectedPlan: SubscriptionPlan
    let plan: SubscriptionPlan


    let selectionFeedback = UISelectionFeedbackGenerator()
    
    var body: some View {
        if let product = purchaseManager.products.first(where: { $0.id == plan.productId }) {

                Button {
                    withAnimation {
                        selectionFeedback.selectionChanged()
                        selectedPlan = plan
                    }
                } label: {
                            HStack {
                                VStack(alignment: .leading,spacing: ScaleUtility.scaledSpacing(3)) {
                                    Text(plan.planName.uppercased())
                                        .font(FontManager.ChakraPetchMediumFont(size: .scaledFontSize(14)))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color.primaryApp.opacity(0.5))
                                    
                                    
                                    Text(displayPriceText(for: plan, product: product))
                                        .font(FontManager.ChakraPetchMediumFont(size: .scaledFontSize(18)))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color.primaryApp.opacity(0.75))
                                }
                                
                                Spacer()
                                
                                    HStack(spacing: ScaleUtility.scaledSpacing(25)) {
                                        Rectangle()
                                            .foregroundColor(Color.primaryApp)
                                            .frame(maxWidth: .infinity)
                                            .frame(width: ScaleUtility.scaledValue(1.5), height: ScaleUtility.scaledValue(50))
                                        
                                        VStack(spacing: ScaleUtility.scaledSpacing(0)) {
                                            
                                            Text("Save")
                                                .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(16)))
                                                .foregroundColor(Color.primaryApp)
                                            
                                            
                                            Text("90%")
                                                .font(FontManager.ChakraPetchMediumFont(size: .scaledFontSize(24)))
                                                .foregroundColor(Color.primaryApp)
                                            
                                        }
                                        
                                        
                                    }
                                    .opacity(plan.planName == "Yearly" && remoteConfigManager.isApproved ? 1 : 0)
                                
                            }
                            .padding(.vertical, ScaleUtility.scaledSpacing(5))
                            .padding(.leading,ScaleUtility.scaledSpacing(15))
                            .padding(.trailing,ScaleUtility.scaledSpacing(25))
                            .background {
                                Rectangle()
                                .foregroundColor(.clear)
                                .background(Color(red: 0.09, green: 0.09, blue: 0.09))
                            }

                        .overlay {
                            if selectedPlan == plan {
                                Image(.paywallPlanOverlay)
                                    .resizable()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: isIPad ? ScaleUtility.scaledValue(80) : ScaleUtility.scaledValue(60))
                            }
                        }
                        .padding(.horizontal,ScaleUtility.scaledSpacing(15))
                }
            
        }
    }
    func displayPriceText(for plan: SubscriptionPlan, product: Product) -> String {
        switch plan {
          case .weekly:
            return  product.displayPrice + " / week"
          case .yearly:
            let price = product.price
              if remoteConfigManager.isApproved {
              let weekPrice = price / 52
              return weekPrice.formatted(product.priceFormatStyle) + " / week"
            } else {
              return product.displayPrice + " / year"
            }
         case .yearlygift:
            return product.displayPrice + " / year"
        }
    }
}

struct PaywallBottmView: View {
    let isProcess: Bool
    @EnvironmentObject var remoteConfigManager: RemoteConfigManager
    @EnvironmentObject var purchaseManager: PurchaseManager
    @Binding var selectedPlan: SubscriptionPlan
    let tryForFreeAction: () -> Void
    @Environment(\.openURL) var openURL
    
    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        VStack(spacing: ScaleUtility.scaledSpacing(15)) {
            
            Button(action: {
                impactFeedback.impactOccurred()
                tryForFreeAction()
            }) {
                HStack(spacing: ScaleUtility.scaledSpacing(5)) {
                    if isProcess {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .tint(Color.primaryApp)
                    }
                    else {
                        Text("Continue")
                            .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(18)))
                            .foregroundColor(Color.primaryApp)
                            .frame(maxWidth: .infinity)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: ScaleUtility.scaledValue(60))
                .background {
                    Image(.buttonBg2)
                        .resizable()
                        .frame(maxWidth: .infinity)
                        .frame(height: ScaleUtility.scaledValue(60))
                        .overlay {
                            Image(.buttonOverlay2)
                                .resizable()
                                .frame(maxWidth: .infinity)
                                .frame(height: ScaleUtility.scaledValue(60))
                        }
                }
                .padding(.horizontal, ScaleUtility.scaledSpacing(15))
            }
    


            if let product = purchaseManager.products.first(where: { $0.id == selectedPlan.productId }) {
                Text(displayPriceText(for: selectedPlan, product: product))
                    .font(FontManager.ChakraPetchMediumFont(size: .scaledFontSize(18)))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.primaryApp)
                    .frame(maxWidth: .infinity, alignment: .top)
            }
            
            
            VStack(spacing: ScaleUtility.scaledSpacing(10)) {
                
                Text("Auto-Renews. Cancel Anytime.")
                    .font(FontManager.ChakraPetchMediumFont(size: .scaledFontSize(12)))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.primaryApp.opacity(0.5))
                
                HStack(spacing: ScaleUtility.scaledSpacing(8)) {
                    
                    Button {
                        impactFeedback.impactOccurred()
                        openURL(URL(string: AppConstant.privacyURL)!)
                    } label: {
                        Text("Privacy Policy")
                            .font(FontManager.ChakraPetchMediumFont(size: .scaledFontSize(12)))
                            .foregroundColor(Color.primaryApp.opacity(0.8))
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Text(" | ")
                        .font(FontManager.ChakraPetchMediumFont(size: .scaledFontSize(12)))
                        .foregroundColor(Color.primaryApp.opacity(0.3))
                    
                    Button {
                        impactFeedback.impactOccurred()
                        openURL(URL(string: AppConstant.termsAndConditionURL)!)
                    } label: {
                        Text("Terms of use")
                            .font(FontManager.ChakraPetchMediumFont(size: .scaledFontSize(12)))
                            .foregroundColor(Color.primaryApp.opacity(0.8))
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                }
                .frame(maxWidth: .infinity)
              
            }
         
        }
    }
    
    func displayPriceText(for plan: SubscriptionPlan, product: Product) -> String {
        switch plan {
          case .weekly:
            return  product.displayPrice + " / Week"
          case .yearly:
            return  product.displayPrice + " / Year"
         case .yearlygift:
            return product.displayPrice + " / Year"
        }
    }
}
