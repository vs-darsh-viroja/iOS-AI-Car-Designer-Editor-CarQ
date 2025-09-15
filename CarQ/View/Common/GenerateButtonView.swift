//
//  GenerateButtonView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 09/09/25.
//

import Foundation
import SwiftUI

struct GenerateButtonView: View {
    
    var isDisabled: Bool
    var action: () -> Void
  
    var body: some View {
        ZStack {
            Image(.bgBlur)
                .resizable()
                .frame(maxWidth: .infinity)
                .frame(height: isIPad ? ScaleUtility.scaledValue(157) : ScaleUtility.scaledValue(117))
                .allowsHitTesting(true)
                .ignoresSafeArea(.all)
            
            
            
            Button {
                action()
            } label: {
                
                Text("Generate")
                    .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(18)))
                    .multilineTextAlignment(.center)
                    .foregroundColor(!isDisabled ? Color.primaryApp : Color.primaryApp.opacity(0.25))
                    .frame(maxWidth: .infinity)
            }
            .disabled(isDisabled)
            .background {
                Image(.buttonBg3)
                    .resizable()
                    .frame(width: isIPad ? ScaleUtility.scaledValue(715) : ScaleUtility.scaledValue(345),
                           height: ScaleUtility.scaledValue(60))
                    .overlay {
                        if !isDisabled {
                            Image(.selectButtonBg)
                                .resizable()
                                .frame(width: isIPad ? ScaleUtility.scaledValue(715) : ScaleUtility.scaledValue(345),
                                       height: ScaleUtility.scaledValue(60))
                        }
                    }
            }
            .padding(.bottom, ScaleUtility.scaledSpacing(26))
            
        }
    }
}
