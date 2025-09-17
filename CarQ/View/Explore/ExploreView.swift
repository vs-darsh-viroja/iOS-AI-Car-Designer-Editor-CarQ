//
//  ExploreView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 08/09/25.
//

import Foundation
import SwiftUI

struct ExploreView: View {
    @State private var selectedFilter: String = "All"
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: ScaleUtility.scaledSpacing(19)) {
                TopView(title: "Explore")
                    .padding(.top, ScaleUtility.scaledSpacing(9))
                
                FilterView(selectedOption: $selectedFilter)
              
            }
            ScrollView {
                
                Spacer()
                    .frame(height: ScaleUtility.scaledValue(25))
                
                ExploreCardView(selectedFilter: selectedFilter)
                
                
                Spacer()
                    .frame(height: ScaleUtility.scaledValue(150))
            }
            
            Spacer()
        }
    }
}
