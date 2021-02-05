//
//  DesenheAiApp.swift
//  DesenheAi
//
//  Created by PATRICIA S SIQUEIRA on 04/02/21.
//

import SwiftUI

@main
struct DesenheAiApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
