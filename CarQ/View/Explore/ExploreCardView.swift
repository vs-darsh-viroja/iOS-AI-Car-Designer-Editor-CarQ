//
//  ExploreCardView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 17/09/25.
//

import Foundation
import SwiftUI
import Kingfisher

struct ExploreCard {
    let imageName: String
    let prompt: String
}

struct ExploreCardView: View {
    let selectedFilter: String
    @State private var navigateToDetail = false
    @State private var selectedCard: ExploreCard?
 
    private var filteredCards: [ExploreCard] {
        if selectedFilter == "All" {
            return getAllCards()
        } else {
            return getCardsForCategory(selectedFilter)
        }
    }
    
    private func getAllCards() -> [ExploreCard] {
        var allCards: [ExploreCard] = []
        let categories = ["Minimal", "Luxury", "Sporty", "Muscular", "Futuristic", "Retro"]
        
        for category in categories {
            allCards.append(contentsOf: getCardsForCategory(category))
        }
        return allCards
    }
    
    private func getCardsForCategory(_ category: String) -> [ExploreCard] {
        let prompts = getPromptsForCategory(category)
        
        return (1...10).map { index in
            ExploreCard(
                imageName: "\(category)\(index)",
                prompt: prompts[index - 1] // index - 1 because array is 0-based
            )
        }
    }
    
    private func getPromptsForCategory(_ category: String) -> [String] {
        switch category {
        case "Minimal":
            return MinimalPrompts.all
        case "Luxury":
            return LuxuryPrompts.all
        case "Sporty":
            return SportyPrompts.all
        case "Muscular":
            return MuscularPrompts.all
        case "Futuristic":
            return FuturisticPrompts.all
        case "Retro":
            return RetroPrompts.all
        default:
            return Array(repeating: "", count: 10)
        }
    }
    
    var body: some View {
            LazyVStack(spacing: ScaleUtility.scaledSpacing(15)) {
                ForEach(Array(stride(from: 0, to: filteredCards.count, by: 2)), id: \.self) { index in
                    HStack(spacing: ScaleUtility.scaledSpacing(15)) {
                        // First card
                        CardItemView(card: filteredCards[index]) {
                            selectedCard = filteredCards[index]
                            navigateToDetail = true
                        }
                        
                        // Second card (if exists)
                        if index + 1 < filteredCards.count {
                            CardItemView(card: filteredCards[index + 1]) {
                                selectedCard = filteredCards[index + 1]
                                navigateToDetail = true
                            }
                        } else {
                            // Empty spacer to maintain layout
                            Spacer()
                                .frame(width: ScaleUtility.scaledValue(165))
                        }
                    }
                    .padding(.horizontal, ScaleUtility.scaledSpacing(16))
                }
            }
          .navigationDestination(isPresented: $navigateToDetail) {
            if let selectedCard = selectedCard {
                ExploreDetailView(card: selectedCard,onBack: {
                    navigateToDetail = false
                })
            }
        }
    }
}

