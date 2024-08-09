//
//  TaskTrackerApp.swift
//  TaskTracker
//
//  Created by Ruzemath on 4/13/24.
//

import SwiftUI
import SwiftData

@main
struct TaskTrackerApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Profile.self, FitnessTask.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
