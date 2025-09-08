//
//  ModifyObjectView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 08/09/25.
//

import Foundation
import SwiftUI

struct ModifyObjectView: View {
    var onBack: () -> Void
    
    var body: some View {
        VStack {
            HeaderView(text: "Modify Object", onBack: {
                onBack()
            })
            .padding(.top, ScaleUtility.scaledSpacing(15))
            
            Spacer()
        }
        .navigationBarHidden(true)
        .background(Color.secondaryApp.ignoresSafeArea(.all))
    }
}
