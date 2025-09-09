//
//  ChangeColorView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 08/09/25.
//

import Foundation
import SwiftUI

struct ChangeColorView: View {
    var onBack: () -> Void
    
    var body: some View {
        VStack {
            HeaderView(text: "Change Color", onBack: {
                onBack()
            })
            .padding(.top, ScaleUtility.scaledSpacing(15))
            
            Spacer()
        }
        .navigationBarHidden(true)
        .ignoresSafeArea(.container, edges: [.bottom])
        .toolbar(.hidden, for: .navigationBar)
        .ignoresSafeArea(.keyboard)
        .navigationBarHidden(true)
        .background(Color.secondaryApp.edgesIgnoringSafeArea(.all))
    }
}
