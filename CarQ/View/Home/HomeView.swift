//
//  HomeView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 08/09/25.
//

import Foundation
import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(spacing: ScaleUtility.scaledSpacing(0)) {
            
            TopView(title: "CarQ")
                .padding(.top, ScaleUtility.scaledSpacing(9))
            
            ScrollView(showsIndicators: false) {
                
                Spacer()
                    .frame(height: ScaleUtility.scaledValue(20))
      
            Image(.createIcon)
                .resizable()
                .frame(width: ScaleUtility.scaledValue(345), height: ScaleUtility.scaledValue(150))
                
                Spacer()
                    .frame(height: ScaleUtility.scaledValue(20))

            ToolsView()
            
            Spacer()
                .frame(height: ScaleUtility.scaledValue(150))
            
        }
        .background(Color.secondaryApp.edgesIgnoringSafeArea(.all))
        
    }
  }
    
}
