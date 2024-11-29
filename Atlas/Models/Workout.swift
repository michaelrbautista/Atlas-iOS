//
//  Workout.swift
//  Atlas
//
//  Created by Michael Bautista on 6/13/24.
//

import SwiftUI

struct Workout: Codable, Identifiable, Hashable {
    var id: String
    var createdAt: String
    var createdBy: String
    
    var programId: String
    var week: Int
    var day: String
    
    var title: String
    var description: String?
    
    var isFree: Bool
    
    var workoutExercises: [WorkoutExercise]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case createdBy = "created_by"
        
        case programId = "program_id"
        case week
        case day
        
        case title
        case description
        
        case isFree = "is_free"
        
        case workoutExercises = "workout_exercises"
    }
}

struct WorkoutExercise: Codable, Identifiable, Hashable {
    var id: String
    var createdAt: String
    var createdBy: String
    
    var workoutId: String
    var exerciseId: String
    
    var exerciseNumber: Int
    var title: String
    var sets: Int
    var reps: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case createdBy = "created_by"
        
        case workoutId = "workout_id"
        case exerciseId = "exercise_id"
        
        case exerciseNumber = "exercise_number"
        case title
        case sets
        case reps
    }
}
