//
//  ExplorePromptView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 17/09/25.
//

import Foundation
import SwiftUI

struct ExplorePromptView: View {
    @Binding var text: String
    @State private var showCopiedPopup = false  // ✅ New state variable

    var body: some View {
        ZStack {
            Image(.promptField)
                .resizable()
                .frame(width:  isIPad ?  ScaleUtility.scaledValue(715) : ScaleUtility.scaledValue(345),
                       height:  isIPad ?  ScaleUtility.scaledValue(210) : ScaleUtility.scaledValue(160))
            

            VStack(spacing: ScaleUtility.scaledSpacing(10)) {
                
                
                Text(text)
                    .foregroundColor(Color.primaryApp)
                    .frame(maxWidth: .infinity)
                    .frame(height:  isIPad ?  ScaleUtility.scaledValue(110) : ScaleUtility.scaledValue(100))
                    .padding(.top, ScaleUtility.scaledSpacing(15))
                    .padding(.horizontal, ScaleUtility.scaledSpacing(30))
                
                
                
                HStack {
                    
                    Spacer()
                    
                    Button(action: {
                        
                        UIPasteboard.general.string = text
                        
                        withAnimation {
                            showCopiedPopup = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation {
                                showCopiedPopup = false
                            }
                        }
                        
                        
                        
                    }) {
                        Image(.copyIcon)
                            .resizable()
                            .frame(width: ScaleUtility.scaledValue(20), height: ScaleUtility.scaledValue(20))
                    }
                    
                }
                .padding(.trailing, ScaleUtility.scaledSpacing(30))
                .padding(.bottom, ScaleUtility.scaledSpacing(15))
            }
        }
        .overlay(alignment:.bottom){
            Group {
                if showCopiedPopup {
                    VStack {
                        Text("Prompt Copied!")
                            .font(.system(size: .scaledFontSize(14)))
                            .fontWeight(.medium)
                            .padding()
                            .background(Color.white.opacity(0.9))
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .transition(.scale)  // ✅ Smooth animation
                    }
                    .offset(y: ScaleUtility.scaledSpacing(50))  // ✅ Adjust position
                }
            }
        }
     
    }
    
    
}
