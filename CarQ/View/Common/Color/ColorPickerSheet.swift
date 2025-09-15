//
//  ColorPickerSheet.swift
//  CarQ
//
//  Created by Purvi Sancheti on 09/09/25.
//

import Foundation
import SwiftUI


struct ColorPickerSheet: View {
    @Binding var uiColor: UIColor
    @Binding var isPresented: Bool
    let onColorApplied: (UIColor) -> Void
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Dark background
            Color.black.ignoresSafeArea(.all)
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    
                    Spacer()
                    
                    Button {
                        isPresented = false
                    } label: {
                        Image(.crossIcon2)
                            .frame(width: ScaleUtility.scaledValue(18), height: ScaleUtility.scaledValue(18))
                            .padding(.all, ScaleUtility.scaledSpacing(5))
                            .background(Color.primaryApp.opacity(0.1))
                            .cornerRadius(30)
                            .overlay(
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(Color.primaryApp.opacity(0.2), lineWidth: 1)
                            )
                
                    }
                    
                    
                }
                .padding(.all, ScaleUtility.scaledSpacing(15))
                .background(Color.black)
                
          
                    SystemColorPicker(
                        uiColor: $uiColor,
                        onDismiss: {
                            // Handle dismiss if needed
                        },
                        onColorSelected: { _ in
                            // Color updates in real-time
                        }
                    )
                    .background(Color.black)
              
                
                Spacer()
                
                Button {
                    onColorApplied(uiColor)
                    isPresented = false
                } label: {
                    
                    Text("Select")
                        .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(18)))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.primaryApp)
                        .frame(maxWidth: .infinity)
                }
                .background {
                 
                        Image(.buttonBg3)
                            .resizable()
                            .frame(width: ScaleUtility.scaledValue(345),
                                   height: ScaleUtility.scaledValue(60))
                            .overlay {
                                Image(.selectButtonBg)
                                    .resizable()
                                    .frame(width:ScaleUtility.scaledValue(345),
                                           height: ScaleUtility.scaledValue(60))
                            }
                    
                }
                .padding(.bottom, ScaleUtility.scaledSpacing(26))
                
            }
          
        }
        .preferredColorScheme(.dark) // Force dark scheme for the entire sheet
    }
}
