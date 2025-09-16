//
//  HistoryFilterView.swift
//  CarQ
//
//  Enhanced with proper filter functionality
//

import Foundation
import SwiftUI

struct HistoryFilterView: View {
    
    @Binding var selectedFilter: String
    let selectionFeedback = UISelectionFeedbackGenerator()
    
    var body: some View {
        HStack {
            HStack(spacing: ScaleUtility.scaledSpacing(5)) {
                
                Button {
                    if selectedFilter != "Generated" {
                        selectionFeedback.selectionChanged()
                        selectedFilter = "Generated"
                    }
                } label: {
                    Text("Generated")
                        .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(14)))
                        .foregroundColor(selectedFilter == "Generated" ? Color.primaryApp : Color.primaryApp.opacity(0.6))
                        .frame(width: isIPad ? 385 * ipadWidthRatio : ScaleUtility.scaledValue(165), height: ScaleUtility.scaledValue(42))
                        .background {
                            if selectedFilter == "Generated" {
                                Image(.toggleBg2)
                                    .resizable()
                                    .frame(width:  isIPad ? 385 * ipadWidthRatio : ScaleUtility.scaledValue(165),
                                           height: ScaleUtility.scaledValue(42))
                            }
                            else {
                                Image(.toggleBg3)
                                    .resizable()
                                    .frame(width: isIPad ? 385 * ipadWidthRatio : ScaleUtility.scaledValue(165),
                                           height: ScaleUtility.scaledValue(42))
                                
                            }
                            
                        }
                        .overlay {
                            if selectedFilter == "Generated" {
                                Image(.toggleOverlay)
                                    .resizable()
                                    .frame(width: isIPad ? 385 * ipadWidthRatio : ScaleUtility.scaledValue(165),
                                           height: ScaleUtility.scaledValue(42))
                            }
                        }
                }
                
                Button {
                    if selectedFilter != "Edited" {
                        selectionFeedback.selectionChanged()
                        selectedFilter = "Edited"
                    }
                } label: {
                    Text("Edited")
                        .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(14)))
                        .foregroundColor(selectedFilter == "Edited" ? Color.primaryApp : Color.primaryApp.opacity(0.6))
                        .frame(width:  isIPad ? 385 * ipadWidthRatio : ScaleUtility.scaledValue(165), height: ScaleUtility.scaledValue(42))
                        .background {
                            if selectedFilter == "Edited" {
                                Image(.toggleBg2)
                                    .resizable()
                                    .frame(width:  isIPad ? 385 * ipadWidthRatio : ScaleUtility.scaledValue(165), height: ScaleUtility.scaledValue(42))
                            }
                            else {
                                Image(.toggleBg3)
                                    .resizable()
                                    .frame(width:  isIPad ? 385 * ipadWidthRatio : ScaleUtility.scaledValue(165), height: ScaleUtility.scaledValue(42))
                            }
                        }
                        .overlay {
                            if selectedFilter == "Edited" {
                                Image(.toggleOverlay)
                                    .resizable()
                                    .frame(width:  isIPad ? 385 * ipadWidthRatio : ScaleUtility.scaledValue(165), height: ScaleUtility.scaledValue(42))
                            }
                        }
                }
            }
            .padding(.horizontal, ScaleUtility.scaledSpacing(5))
        }
        .background {
            Image(.toggleBg1)
                .resizable()
                .frame(maxWidth: .infinity)
                .frame(height: ScaleUtility.scaledValue(50))
        }
        .padding(.horizontal, ScaleUtility.scaledSpacing(15))
    }
}
