//
//  PagingTabView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 18/09/25.
//


import Foundation
import SwiftUI


struct PagingTabView<Content: View>: View {
    @Binding var selectedIndex: Int
    let tabCount: Int
    let spacing: CGFloat
    let content: () -> Content
    var indicatorRequired: Bool = true
    var buttonAction: () -> Void
    
  
    let impactfeedback = UIImpactFeedbackGenerator(style: .light)

    
    var body: some View {
        ZStack(alignment:.bottom) {
            
            // TabView with Paging Style
            TabView(selection: $selectedIndex) {
                content()
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Hide default dots
            
            //Custom Page Indicator
            
            VStack(spacing: ScaleUtility.scaledSpacing(20)) {
                
                HStack(spacing: ScaleUtility.scaledSpacing(10)) {
                    
                    HStack(spacing: ScaleUtility.scaledSpacing(4)) {
                        ForEach(0..<tabCount, id: \.self) { index in
                            Group {
                                if selectedIndex == index {
                                    Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: ScaleUtility.scaledValue(16), height: ScaleUtility.scaledValue(8))
                                    .background(Color.primaryApp)
                                    
                                } else {
                                    Rectangle()
                                      .foregroundColor(.clear)
                                      .frame(width: ScaleUtility.scaledValue(8), height: ScaleUtility.scaledValue(8))
                                      .background(Color.primaryApp.opacity(0.2))
                                      
                                }
                            }
                        }
                    }
                 
                    
                }
                .animation(.easeInOut, value: selectedIndex)
                .frame(maxWidth: .infinity)
                .opacity(indicatorRequired ? 1 : 0)
                .offset(y: ScaleUtility.scaledSpacing(-20))
                
                Button {
                
                    impactfeedback.impactOccurred()
                    buttonAction()
                    print("Button Clicked")
            
                } label: {
                    
                    Text(selectedIndex == 0 ? "Get Started" : "Continue")
                        .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(18)))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.primaryApp)
                        .frame(maxWidth: .infinity)
                }
                .background {
                    Image(.buttonBg3)
                        .resizable()
                        .frame(width: isIPad ? ScaleUtility.scaledValue(715) : ScaleUtility.scaledValue(345),
                               height: ScaleUtility.scaledValue(60))
                        .overlay {
    
                                Image(.selectButtonBg)
                                    .resizable()
                                    .frame(width: isIPad ? ScaleUtility.scaledValue(715) : ScaleUtility.scaledValue(345),
                                           height: ScaleUtility.scaledValue(60))
                            
                        }
                }
                .zIndex(1)
        
                
            }
            .padding(.bottom, isSmallDevice ? ScaleUtility.scaledSpacing(20) : ScaleUtility.scaledSpacing(40))

            

        }
        .ignoresSafeArea(.container, edges: [.top,.bottom])
        .toolbar(.hidden, for: .navigationBar)
        .background {Color.clear.edgesIgnoringSafeArea(.all)}
        
    }
}

