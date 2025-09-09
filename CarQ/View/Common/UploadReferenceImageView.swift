//
//  UploadReferenceImageView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 09/09/25.
//

import Foundation
import SwiftUI

struct UploadReferenceImageView: View {
    var isOptional: Bool
    
    var body: some View {
        Image(.uploadBg2)
            .resizable()
            .frame(width: isIPad ?  ScaleUtility.scaledValue(715) : ScaleUtility.scaledValue(345),
                   height: isIPad ?  ScaleUtility.scaledValue(210) :  ScaleUtility.scaledValue(160))
            .overlay {
                VStack(spacing:0) {
                    Image(.addIcon2)
                        .resizable()
                        .frame(width: ScaleUtility.scaledValue(52), height: ScaleUtility.scaledValue(52))
                    
                    Text( isOptional ? "Upload Reference Image\n( Optional )" : "Upload Reference Image")
                        .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(16)))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .opacity(0.5)
                }
            }
    }
}
