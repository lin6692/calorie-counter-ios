//
//  calorie_counter_iosApp.swift
//  calorie-counter-ios
//
//  Created by Lin Liu on 8/5/22.
//

import SwiftUI

@main
struct calorie_counter_iosApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
