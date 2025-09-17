//
//  UploadImageSheetView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 10/09/25.
//

import Foundation
import Foundation
import SwiftUI

struct UploadImageSheetView: View {
    @Binding var showSheet: Bool
    var onCameraTap: () -> Void
    var onGalleryTap: () -> Void
 
    var body: some View {
     
            ZStack {
                
                Image(.sheetBg)
                    .resizable()
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                    .ignoresSafeArea(.all)
               
                VStack(spacing: ScaleUtility.scaledSpacing(22)) {
                    
                    Text("Upload an Image")
                        .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(18)))
                        .foregroundColor(Color.primaryApp)
                    
                    HStack(spacing: ScaleUtility.scaledSpacing(28)) {
                        
                        Button {
                            onCameraTap()
                        } label: {
                            Image(.cameraIcon)
                                .resizable()
                                .frame(width: isIPad ? ScaleUtility.scaledValue(150) : ScaleUtility.scaledValue(100),
                                       height: isIPad ? ScaleUtility.scaledValue(150) : ScaleUtility.scaledValue(100))
                        }
                        
                        Rectangle()
                            .frame(width: ScaleUtility.scaledValue(2),height: isIPad ?  ScaleUtility.scaledValue(100) : ScaleUtility.scaledValue(60))
                            .foregroundColor(Color.primaryApp.opacity(0.5))
                        
                        Button {
                            onGalleryTap()
                        } label: {
                            Image(.galleryIcon)
                                .resizable()
                                .frame(width: isIPad ? ScaleUtility.scaledValue(150) : ScaleUtility.scaledValue(100),
                                       height: isIPad ? ScaleUtility.scaledValue(150) : ScaleUtility.scaledValue(100))
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity,maxHeight: .infinity)
 
         
    }
}

