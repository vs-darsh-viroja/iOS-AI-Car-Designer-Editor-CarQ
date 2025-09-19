//
//  HeaderView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 08/09/25.
//

import Foundation
import SwiftUI

struct HeaderView: View {
    var text: String
    var onBack: () -> Void
    var onClose: () -> Void
    var isCross: Bool
    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View {
        HStack {
            HStack(spacing: ScaleUtility.scaledSpacing(15)) {
                Button {
                    impactFeedback.impactOccurred()
                    onBack()
                } label: {
                    Image(.backIcon)
                        .resizable()
                        .frame(width: ScaleUtility.scaledValue(24), height:  ScaleUtility.scaledValue(24))
                }
                
                Text(text)
                    .font(FontManager.ChakraPetchMediumFont(size: .scaledFontSize(24)))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
           
                Button {
                    impactFeedback.impactOccurred()
                    onClose()
                } label: {
                    Image(.crossIcon)
                        .resizable()
                        .frame(width: ScaleUtility.scaledValue(24), height: ScaleUtility.scaledValue(24))
                        .padding(.all, ScaleUtility.scaledSpacing(9))
                        .background {
                            Circle()
                                .fill(Color.primaryApp.opacity(0.1))
                        }
                        .cornerRadius(45)
                }
                .opacity(isCross ? 1 : 0)
       
            
      
        }
        .padding(.horizontal, ScaleUtility.scaledSpacing(15))
    }
}
