//
//  MainView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 08/09/25.
//

import Foundation
import SwiftUI

enum TabSelection: Hashable {
    case home
    case explore
    case history
    case settings
}


struct MainView: View {
    
    @State var selectedTab: TabSelection = .home
    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View {
        
        NavigationStack {
            ZStack(alignment: .bottom) {
                Group {
                    switch selectedTab {
                    case .home:
                        HomeView()
                    case .explore:
                        ExploreView()
                    case .history:
                        HistoryView()
                    case .settings:
                        SettingsView()
                    }
                }
                .frame(maxWidth:.infinity)
                .transition(.opacity)
                
                
                VStack {
                    Spacer()
                    
                    ZStack {
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.black.opacity(0.8),
                                        Color.black.opacity(0.4),
                                        Color.black.opacity(0.0)
                                    ]),
                                    startPoint: .bottom,
                                    endPoint: .top
                                )
                               
                            )
                            .ignoresSafeArea(.all)
                            .frame(height: 150)
                            .allowsHitTesting(true)
                            .offset(y: ScaleUtility.scaledSpacing(30))
                        
                        HStack {
                            
                            HStack(spacing: ScaleUtility.scaledSpacing(4)) {
                                VStack(spacing: ScaleUtility.scaledSpacing(5)) {
                                    Button {
                                        selectedTab = .home
                                    } label: {
                                        VStack(spacing: ScaleUtility.scaledSpacing(1)) {
                                            Image(.homeIcon)
                                                .renderingMode(.template)
                                                .resizable()
                                                .foregroundColor(Color.primaryApp)
                                                .frame(width: ScaleUtility.scaledValue(24), height: ScaleUtility.scaledValue(24))
                                                .opacity(selectedTab == .home ? 1 : 0.25)
                                            
                                            Text("Home")
                                                .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(10)))
                                                .multilineTextAlignment(.center)
                                                .frame(width: ScaleUtility.scaledValue(48))
                                                .foregroundColor( selectedTab == .home ? Color.primaryApp : Color.primaryApp.opacity(0.25) )
                                        }
                                        
                                    }
                                    
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                stops: [
                                                    Gradient.Stop(color: Color(red: 0.99, green: 0.73, blue: 0.3), location: 0.00),
                                                    Gradient.Stop(color: Color(red: 1, green: 0.33, blue: 0.4), location: 1.00),
                                                ],
                                                startPoint: UnitPoint(x: 0, y: 0.5),
                                                endPoint: UnitPoint(x: 1, y: 0.5)
                                            )
                                        )
                                        .frame(width: ScaleUtility.scaledValue(5), height: ScaleUtility.scaledValue(5))
                                        .opacity(selectedTab == .home ? 1 : 0)
                                    
                                }
                                
                                VStack(spacing: ScaleUtility.scaledSpacing(5)) {
                                    Button {
                                        selectedTab = .explore
                                    } label: {
                                        VStack(spacing: ScaleUtility.scaledSpacing(1)) {
                                            Image(.historyIcon)
                                                .renderingMode(.template)
                                                .resizable()
                                                .foregroundColor(Color.primaryApp)
                                                .frame(width:ScaleUtility.scaledValue(24), height: ScaleUtility.scaledValue(24))
                                                .opacity(selectedTab == .explore ? 1 : 0.25)
                                            
                                            Text("Explore")
                                                .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(10)))
                                                .multilineTextAlignment(.center)
                                                .frame(width: ScaleUtility.scaledValue(48))
                                                .foregroundColor( selectedTab == .explore ? Color.primaryApp : Color.primaryApp.opacity(0.25) )
                                        }
                                        
                                    }
                                    
                                    
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                stops: [
                                                    Gradient.Stop(color: Color(red: 0.99, green: 0.73, blue: 0.3), location: 0.00),
                                                    Gradient.Stop(color: Color(red: 1, green: 0.33, blue: 0.4), location: 1.00),
                                                ],
                                                startPoint: UnitPoint(x: 0, y: 0.5),
                                                endPoint: UnitPoint(x: 1, y: 0.5)
                                            )
                                        )
                                        .frame(width: ScaleUtility.scaledValue(5), height: ScaleUtility.scaledValue(5))
                                        .opacity(selectedTab == .explore ? 1 : 0)
                                    
                                    
                                }
                                
                            }
                            
                            
                            Spacer()
                            
                            HStack(spacing: ScaleUtility.scaledSpacing(4)) {
                                VStack(spacing: ScaleUtility.scaledSpacing(5)) {
                                    Button {
                                        selectedTab = .history
                                    } label: {
                                        VStack(spacing: ScaleUtility.scaledSpacing(1)) {
                                            Image(.historyIcon)
                                                .renderingMode(.template)
                                                .resizable()
                                                .foregroundColor(Color.primaryApp)
                                                .frame(width: ScaleUtility.scaledValue(24), height: ScaleUtility.scaledValue(24))
                                                .opacity(selectedTab == .history ? 1 : 0.25)
                                            
                                            Text("History")
                                                .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(10)))
                                                .multilineTextAlignment(.center)
                                                .frame(width: ScaleUtility.scaledValue(48))
                                                .foregroundColor( selectedTab == .history ? Color.primaryApp : Color.primaryApp.opacity(0.25) )
                                        }
                                        
                                    }
                                    
                                    
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                stops: [
                                                    Gradient.Stop(color: Color(red: 0.99, green: 0.73, blue: 0.3), location: 0.00),
                                                    Gradient.Stop(color: Color(red: 1, green: 0.33, blue: 0.4), location: 1.00),
                                                ],
                                                startPoint: UnitPoint(x: 0, y: 0.5),
                                                endPoint: UnitPoint(x: 1, y: 0.5)
                                            )
                                        )
                                        .frame(width: ScaleUtility.scaledValue(5), height: ScaleUtility.scaledValue(5))
                                        .opacity(selectedTab == .history ? 1 : 0)
                                    
                                    
                                }
                                
                                VStack(spacing: ScaleUtility.scaledSpacing(5)) {
                                    Button {
                                        selectedTab = .settings
                                    } label: {
                                        VStack(spacing: ScaleUtility.scaledSpacing(1)) {
                                            Image(.settingsIcon)
                                                .renderingMode(.template)
                                                .resizable()
                                                .frame(width: ScaleUtility.scaledValue(24), height: ScaleUtility.scaledValue(24))
                                                .foregroundColor(Color.primaryApp)
                                                .opacity(selectedTab == .settings ? 1 : 0.25)
                                            
                                            Text("Settings")
                                                .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(10)))
                                                .multilineTextAlignment(.center)
                                                .frame(width: ScaleUtility.scaledValue(48))
                                                .foregroundColor( selectedTab == .settings ? Color.primaryApp : Color.primaryApp.opacity(0.25) )
                                        }
                                        
                                    }
                                    
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                stops: [
                                                    Gradient.Stop(color: Color(red: 0.99, green: 0.73, blue: 0.3), location: 0.00),
                                                    Gradient.Stop(color: Color(red: 1, green: 0.33, blue: 0.4), location: 1.00),
                                                ],
                                                startPoint: UnitPoint(x: 0, y: 0.5),
                                                endPoint: UnitPoint(x: 1, y: 0.5)
                                            )
                                        )
                                        .frame(width: ScaleUtility.scaledValue(5), height: ScaleUtility.scaledValue(5))
                                        .opacity(selectedTab == .settings ? 1 : 0)
                                    
                                }
                                
                            }
                            
                            
                        }
                        .padding(.horizontal, ScaleUtility.scaledSpacing(52))
                        .background {
                            Image(.tabview)
                                .resizable()
                                .frame(width: ScaleUtility.scaledValue(310), height: ScaleUtility.scaledValue(70))
                            
                            
                        }
                        .overlay(alignment: .top) {
                            Image(.steeringIcon)
                                .resizable()
                                .frame(width: ScaleUtility.scaledValue(58), height: ScaleUtility.scaledValue(58))
                                .offset(y: ScaleUtility.scaledSpacing(-45))
                        }
                        .offset(y: ScaleUtility.scaledSpacing(30))
                        
                        
                    }
                    .ignoresSafeArea(.all)
                }
              
            }
            .background(Color.secondaryApp.ignoresSafeArea(.all))
        }
    }
}
