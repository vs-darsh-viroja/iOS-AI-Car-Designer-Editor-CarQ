//
//  CommonRowView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 12/09/25.
//

import Foundation
import SwiftUI

struct CommonRowView: View {
    // MARK: - PROPERTIES
    @State var rowText: String
    @State var rowImage: String

    var body: some View {
        HStack(spacing: ScaleUtility.scaledSpacing(10)) {

                Image(rowImage)
                .resizable()
                .frame(width: isIPad ? 32 * ipadWidthRatio : 22,  height: isIPad ? 32 * ipadHeightRatio : 22)
                .foregroundColor(Color.primaryApp)

               Text(rowText)
                  .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(14)))
                  .foregroundColor(Color.primaryApp)
          
            Spacer()
        }
       
    
    }
}
