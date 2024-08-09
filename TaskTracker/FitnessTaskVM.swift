//
//  FitnessTaskVM.swift
//  TaskTracker
//
//  Created by Ruzemath on 4/13/24.
//

import Foundation
import SwiftData

@Observable
class FitnessTaskVM: ObservableObject {
    var modelContext: ModelContext? = nil
    var tasks: [FitnessTask] = []
    var completedTasks: [FitnessTask] = []
    
    func fetchTasks() {
        let descriptor = FetchDescriptor<FitnessTask>(
            sortBy: [SortDescriptor(\.points)]
        )
        tasks = (try? (modelContext?.fetch(descriptor) ?? [])) ?? []
    }
    
    func addTask(task: FitnessTask) {
        modelContext?.insert(task)
        try? modelContext?.save()
        fetchTasks()
    }
    
    func removeTask(task: FitnessTask) {
        modelContext?.delete(task)
        try? modelContext?.save()
        fetchTasks()
    }
    
    func addCompletedTask(task: FitnessTask) {
        completedTasks.append(task)
    }
    
    func markTaskAsCompleted(completedTask: FitnessTask) {
        if completedTask.isCompleted == true {
            addCompletedTask(task: completedTask)
        }
    }
    
}
