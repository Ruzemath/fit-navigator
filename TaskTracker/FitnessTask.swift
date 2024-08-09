//
//  FitnessTask.swift
//  TaskTracker
//
//  Created by Ruzemath on 4/13/24.
//

import Foundation
import SwiftData

@Model
class FitnessTask: Identifiable {
    @Attribute(.unique) public var id: UUID
    @Attribute var name: String
    @Attribute var type: String
    @Attribute var duration: String
    @Attribute var difficulty: Difficulty
    @Attribute var points: Int
    @Attribute var isCompleted: Bool
    
    init(id: UUID, name: String, type: String, duration: String, difficulty: Difficulty, points: Int, isCompleted: Bool) {
        self.id = id
        self.name = name
        self.type = type
        self.duration = duration
        self.difficulty = difficulty
        self.points = difficulty.points
        self.isCompleted = isCompleted
    }
}

enum Difficulty: String, Codable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    case intense = "Intense"
    
    var points: Int {
        switch self {
        case .easy:
            return 5
        case .medium:
            return 10
        case .hard:
            return 15
        case .intense:
            return 25
        }
    }
}
