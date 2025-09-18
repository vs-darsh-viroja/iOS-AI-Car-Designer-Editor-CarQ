//
//  QuestionsView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 18/09/25.
//

import Foundation
import SwiftUI

struct QuestionsView: View {
    @Binding var selectedOptions: Set<String>
    private let templateOptions: [String] = [
        "Create Dream Car",
        "Modify Existing Car",
        "Transform Style",
        "Repaint in Any Color",
        "Add or\nRemove Objects"
    ]
        
    var body: some View {
        VStack(spacing: 0) {
            
            VStack(spacing: ScaleUtility.scaledSpacing(30)) {
                
                VStack(spacing: ScaleUtility.scaledSpacing(16)) {
                    Text("How You'll Use CarQ?")
                        .font(FontManager.ChakraPetchSemiBoldFont(size: .scaledFontSize(32)))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.primaryApp)
                    
                    Text("Select one or many")
                        .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(24)))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.primaryApp.opacity(0.75))
                }
                
                // Create rows of 2 buttons each using for loop
                VStack(spacing:  ScaleUtility.scaledSpacing(15)) {
                    ForEach(0..<3, id: \.self) { rowIndex in
                        HStack(spacing: isIPad ? ScaleUtility.scaledSpacing(21) : ScaleUtility.scaledSpacing(11)) {
                            // First button in row
                            if rowIndex * 2 < templateOptions.count {
                                SelectionButton(
                                    title: templateOptions[rowIndex * 2],
                                    isSelected: selectedOptions.contains(templateOptions[rowIndex * 2])
                                ) {
                                    toggleSelection(templateOptions[rowIndex * 2])
                                }
                            }
                            
                            // Second button in row
                            if rowIndex * 2 + 1 < templateOptions.count {
                                SelectionButton(
                                    title: templateOptions[rowIndex * 2 + 1],
                                    isSelected: selectedOptions.contains(templateOptions[rowIndex * 2 + 1])
                                ) {
                                    toggleSelection(templateOptions[rowIndex * 2 + 1])
                                }
                            } else {
                                // Empty space if odd number of items
                                Spacer()
                                    .frame(width: isIPad ? ScaleUtility.scaledValue(327) : ScaleUtility.scaledValue(167))
                            }
                        }
                    }
                }
            }
            .padding(.top, ScaleUtility.scaledSpacing(79))
            
            Spacer()
            
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .ignoresSafeArea(.container, edges: [.bottom])
        .toolbar(.hidden, for: .navigationBar)
        .background {
            Image(.onboarding8)
                .resizable()
                .ignoresSafeArea(.all)
        }
        .ignoresSafeArea(.all)
    }
    
    private func toggleSelection(_ option: String) {
        if selectedOptions.contains(option) {
            selectedOptions.remove(option)
        } else {
            selectedOptions.insert(option)
        }
    }
}
