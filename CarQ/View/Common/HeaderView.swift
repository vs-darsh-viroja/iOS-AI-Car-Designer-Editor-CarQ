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
    
    var body: some View {
        HStack {
            HStack(spacing: ScaleUtility.scaledSpacing(15)) {
                Button {
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
            
            if isCross {
                Button {
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

       
            }
            else {
                Image(.crownIcon)
                    .resizable()
                    .frame(width: ScaleUtility.scaledValue(42), height: ScaleUtility.scaledValue(42))
            }
        }
        .padding(.horizontal, ScaleUtility.scaledSpacing(15))
    }
}
