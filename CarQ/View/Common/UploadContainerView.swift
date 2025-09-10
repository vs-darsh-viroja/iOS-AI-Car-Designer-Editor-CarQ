//
//  UploadContainer.swift
//  CarQ
//
//  Created by Purvi Sancheti on 08/09/25.
//

import Foundation
import SwiftUI

struct UploadContainerView: View {
    var body: some View {
        
        Image(.updloadBg1)
            .resizable()
            .frame(width: isIPad ?  ScaleUtility.scaledValue(715) : ScaleUtility.scaledValue(345),
                   height: isIPad ?  ScaleUtility.scaledValue(395) :  ScaleUtility.scaledValue(345))
            .overlay {
                VStack(spacing: ScaleUtility.scaledSpacing(4)) {
                    Image(.addIcon1)
                        .resizable()
                        .frame(width: ScaleUtility.scaledValue(52), height: ScaleUtility.scaledValue(52))
                        .opacity(0.5)
                    
                    Text("Upload your Car Image")
                        .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(16)))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.primaryApp.opacity(0.5))
                        
                }
            }
    }
}
