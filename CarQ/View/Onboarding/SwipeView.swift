//
//  SwipeView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 18/09/25.
//

import Foundation
import SwiftUI

struct SwipeView: View {
    
    @State private var currentIndex = 0
    @State private var shownextScreen = false
    let totalScreens = 8
    var showPaywall: () -> Void
    @State private var selections: Set<String> = []
    @AppStorage("currentOnboardingIndex") private var currentOnboardingIndex: Int = 0
    
    var screens: [AnyView] {
        [
            AnyView(WelcomeView()),
            AnyView(OnboardingView(imageName: "onboarding2",
                                   title: "Create Cars",
                                   subtitle: "AI builds your dream vehicle",
                                   screenIndex: 1)),
            AnyView(OnboardingView(imageName: "onboarding3",
                                   title: "Modify\nAnything",
                                   subtitle: "Edit parts with a tap",
                                   screenIndex: 2)),
            AnyView(OnboardingView(imageName: "onboarding4",
                                   title: "Change\nColors",
                                   subtitle: "Repaint in any style",
                                   screenIndex: 3)),
            AnyView(OnboardingView(imageName: "onboarding5",
                                   title: "Add &\nReplace",
                                   subtitle: "Wheels, Spoilers, Lights & More",
                                   screenIndex: 4)),
            AnyView(RatingView()),
            AnyView(UserCommentsView()),
            AnyView(QuestionsView(selectedOptions: $selections))
        ]
    }

    
    let notificationfeedback = UINotificationFeedbackGenerator()
    let impactfeedback = UIImpactFeedbackGenerator(style: .medium)
    let selectionfeedback = UISelectionFeedbackGenerator()
    
    var body: some View {
        PagingTabView(selectedIndex: $currentIndex, tabCount: totalScreens, spacing: 0) {
            Group {
                
                WelcomeView()
                    .tag(0)
                
                OnboardingView(imageName: "onboarding2",
                                       title: "Create Cars",
                                       subtitle: "AI builds your dream vehicle",
                                       screenIndex: 1)
                    .tag(1)
                
                OnboardingView(imageName: "onboarding3",
                                       title: "Modify\nAnything",
                                       subtitle: "Edit parts with a tap",
                                       screenIndex: 2)
                    .tag(2)
                
                OnboardingView(imageName: "onboarding4",
                                       title: "Change\nColors",
                                       subtitle: "Repaint in any style",
                                       screenIndex: 3)
                    .tag(3)
                
                OnboardingView(imageName: "onboarding5",
                                       title: "Add &\nReplace",
                                       subtitle: "Wheels, Spoilers, Lights & More",
                                       screenIndex: 4)
                .tag(4)
            
                
                RatingView()
                    .tag(5)
                
                UserCommentsView()
                    .tag(6)
                
                QuestionsView(selectedOptions: $selections)
                    .tag(7)
                
            }
        } buttonAction: {
            handleButtonPress()
        }
        .animation(.easeInOut(duration: 0.3), value: currentIndex)
        .onChange(of: currentIndex) { _, newValue in
            currentOnboardingIndex = newValue // This tracks both button presses and swipes
        }
        .onAppear {
            // Ensure AppStorage is initialized on first launch
            currentOnboardingIndex = currentIndex
            print("SwipeView appeared, initialized currentOnboardingIndex to: \(currentOnboardingIndex)")
        }
    }
    
    // MARK: - Button Press Logic
    private func handleButtonPress() {
        // Add haptic feedback first
        if currentIndex == 7 {
               showPaywall()
           }
           else {
               self.currentIndex += 1
               currentOnboardingIndex = currentIndex // Add this single line
           }
    }

  }

