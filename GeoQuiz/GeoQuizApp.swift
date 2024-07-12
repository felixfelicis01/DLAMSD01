//
//  GeoQuizApp.swift
//  GeoQuiz
//
//  Created by Felix Horn on 07.06.24.
//

import SwiftUI

@main
struct GeoQuizApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
