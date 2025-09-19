//
//  HistoryFilterView.swift
//  CarQ
//
//  Enhanced with sliding toggle effect like CustomTabPicker
//

import Foundation
import SwiftUI

struct HistoryFilterView: View {
    
    @Binding var selectedFilter: String
    let selectionFeedback = UISelectionFeedbackGenerator()
    
    // Define the tabs
    private let tabs = ["Generated", "Edited"]
    
    var body: some View {
        ZStack {
            // Background
            Image(.toggleBg1)
                .resizable()
                .frame(maxWidth: .infinity)
                .frame(height: ScaleUtility.scaledValue(50))
            
            GeometryReader { geometry in
                let containerWidth = geometry.size.width
                let tabButtonWidth = isIPad ? 385 * ipadWidthRatio : ScaleUtility.scaledValue(165)
                let spacing = ScaleUtility.scaledSpacing(5)
                let totalTabsWidth = (tabButtonWidth * 2) + spacing
                let leadingOffset = (containerWidth - totalTabsWidth) / 2
                
                ZStack(alignment: .leading) {
                    // Sliding active indicator
                    ZStack {
                        Image(.toggleBg2)
                            .resizable()
                            .frame(width: tabButtonWidth, height: ScaleUtility.scaledValue(42))
                        
                        Image(.toggleOverlay)
                            .resizable()
                            .frame(width: tabButtonWidth, height: ScaleUtility.scaledValue(42))
                    }
                    .offset(x: getActiveTabOffset(
                        leadingOffset: leadingOffset,
                        tabWidth: tabButtonWidth,
                        spacing: spacing
                    ),y: ScaleUtility.scaledSpacing(4))
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: selectedFilter)
                    
                    // Static inactive backgrounds and buttons
                    HStack(spacing: spacing) {
                        ForEach(tabs.indices, id: \.self) { index in
                            ZStack {
                                // Show inactive background only when not selected
                                if selectedFilter != tabs[index] {
                                    Image(.toggleBg3)
                                        .resizable()
                                        .frame(width: tabButtonWidth, height: ScaleUtility.scaledValue(42))
                                }
                                
                                Button(action: {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                        if selectedFilter != tabs[index] {
                                            selectionFeedback.selectionChanged()
                                            selectedFilter = tabs[index]
                                        }
                                    }
                                }) {
                                    Text(tabs[index])
                                        .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(14)))
                                        .foregroundColor(selectedFilter == tabs[index] ? Color.primaryApp : Color.primaryApp.opacity(0.6))
                                        .frame(width: tabButtonWidth, height: ScaleUtility.scaledValue(42))
                                        .offset(y: ScaleUtility.scaledSpacing(4))
                                }
                            }
                        }
                    }
                    .offset(x: leadingOffset)
                }
            }
        }
        .padding(.horizontal, ScaleUtility.scaledSpacing(15))
        .frame(height: ScaleUtility.scaledValue(50))
    }
    
    // Helper function to calculate active tab offset with proper centering
    private func getActiveTabOffset(leadingOffset: CGFloat, tabWidth: CGFloat, spacing: CGFloat) -> CGFloat {
        let selectedIndex = tabs.firstIndex(of: selectedFilter) ?? 0
        return leadingOffset + (CGFloat(selectedIndex) * (tabWidth + spacing))
    }
}

#Preview {
    HistoryFilterView(selectedFilter: .constant("Generated"))
}
