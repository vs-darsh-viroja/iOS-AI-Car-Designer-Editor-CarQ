//
//  ForceUpdateAlertView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 18/09/25.
//


import Foundation
import SwiftUI

struct ForceUpdateAlertView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            Color.secondaryApp.opacity(0.8)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: ScaleUtility.scaledSpacing(20) ) {
                // Header
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(50)))
                    .foregroundColor(Color.red)
                    .padding(.top,  ScaleUtility.scaledSpacing(30))
                
                Text("Update Required")
                    .font(FontManager.ChakraPetchMediumFont(size:.scaledFontSize(18)))
                    .foregroundColor(Color.primaryApp)
                
                Text("A new version is available. Please update to continue using the app.")
                    .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(15)))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, .scaledFontSize(20))
                    .foregroundColor(Color.primaryApp)
                
                Divider()
                    .background(Color.primaryApp)
                    .offset(y:.scaledFontSize(10))
                
                Button(action: {
                    self.openAppInAppStore()
//                    AnalyticsManager.shared.log(.noOfUserUpdatedApp)
                })
                {
                    Text("Update Now")
                        .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(20)))
                        .foregroundColor(Color.blue)
                }
                .padding(.top, .scaledFontSize(10))
                .padding(.bottom, .scaledFontSize(30))
                .buttonStyle(.plain)
            }
            .frame(width: UIScreen.main.bounds.width - 60)
            .background(Color.secondaryApp.ignoresSafeArea(.all))
            .cornerRadius(25)
            .shadow(radius: 10)
        }
        .ignoresSafeArea()
    }
    
    private func openAppInAppStore() {
        if let appStoreUrl = URL(string: AppConstant.shareAppIDURL) {
            UIApplication.shared.open(appStoreUrl)
        }
    }
}

#Preview {
    ForceUpdateAlertView()
}

