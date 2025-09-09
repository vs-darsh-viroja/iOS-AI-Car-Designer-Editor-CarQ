//
//  RemoveObjectView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 08/09/25.
//

import Foundation
import SwiftUI

struct RemoveObjectView: View {
    var onBack: () -> Void
    
    var body: some View {
        VStack {
            HeaderView(text: "Remove Object", onBack: {
                onBack()
            })
            .padding(.top, ScaleUtility.scaledSpacing(15))
            
            
            UploadContainerView()
            
            
            Spacer()
            
            GenerateButtonView(isDisabled: true, action: {
                
            })
        }
        .ignoresSafeArea(.container, edges: [.bottom])
        .toolbar(.hidden, for: .navigationBar)
        .ignoresSafeArea(.keyboard)
        .navigationBarHidden(true)
        .background(Color.secondaryApp.edgesIgnoringSafeArea(.all))
    }
}
