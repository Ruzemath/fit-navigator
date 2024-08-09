//
//  Profile.swift
//  TaskTracker
//
//  Created by Ruzemath on 4/13/24.
//

import Foundation
import SwiftData

@Model
class Profile {
    @Attribute var name: String
    @Attribute var username: String
    @Attribute var age: String
    @Attribute var pointsEarned: Int
    @Attribute var goals: String
    @Attribute var profileDescription: String
    
    init(name: String, username: String, age: String, pointsEarned: Int, goals: String, profileDescription: String) {
        self.name = name
        self.username = username
        self.age = age
        self.pointsEarned = pointsEarned
        self.goals = goals
        self.profileDescription = profileDescription
    }
}

