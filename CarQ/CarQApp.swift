//
//  CarQApp.swift
//  CarQ
//
//  Created by Purvi Sancheti on 06/09/25.
//

import SwiftUI

@main
struct CarQApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
