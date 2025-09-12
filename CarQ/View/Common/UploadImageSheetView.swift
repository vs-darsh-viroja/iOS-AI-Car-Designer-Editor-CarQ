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
                
                EllipticalGradient(
                    stops: [
                        Gradient.Stop(color: .white.opacity(0.4), location: 0.00),
                        Gradient.Stop(color: Color(red: 0.61, green: 0.61, blue: 0.61).opacity(0.5), location: 0.78),
                    ],
                    center: UnitPoint(x: 0.18, y: 0.04)
                    
                )
                .ignoresSafeArea(.all)
                
                Color.secondaryApp.opacity(0.9).ignoresSafeArea(.all)
                
   
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
                                .frame(width: ScaleUtility.scaledValue(100), height: ScaleUtility.scaledValue(100))
                        }
                        
                        Rectangle()
                            .frame(width: ScaleUtility.scaledValue(2),height: ScaleUtility.scaledValue(60))
                            .foregroundColor(Color.primaryApp.opacity(0.5))
                        
                        Button {
                            onGalleryTap()
                        } label: {
                            Image(.galleryIcon)
                                .resizable()
                                .frame(width: ScaleUtility.scaledValue(100), height: ScaleUtility.scaledValue(100))
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity,maxHeight: .infinity)
 
         
    }
}

