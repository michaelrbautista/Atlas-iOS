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

struct FetchedWorkout: Codable, Hashable, Identifiable {
    var id: String
    var createdBy: String
    var title: String
    var description: String?
    
    var workoutExercises: [FetchedWorkoutExercise]?
    
    enum CodingKeys: String, CodingKey {
        case id, title, description
        case createdBy = "created_by"
        case workoutExercises = "workout_exercises"
    }
}

struct FetchedWorkoutExercise: Codable, Hashable, Identifiable {
    var id: String
    var createdBy: String
    var exerciseId: String
    var exerciseNumber: Int
    var sets: Int?
    var reps: Int?
    var time: String?
    var other: String?
    
    var exercises: FetchedExercise?
    
    enum CodingKeys: String, CodingKey {
        case id, sets, reps, time, other, exercises
        case createdBy = "created_by"
        case exerciseId = "exercise_id"
        case exerciseNumber = "exercise_number"
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

struct CreateWorkoutRequest: Codable {
    var title: String
    var description: String?
    
    enum CodingKeys: String, CodingKey {
        case title, description
    }
}

struct addWorkoutToProgramRequest: Codable {
    var title: String
    var description: String?
    var programId: String
    var week: Int
    var day: String
    
    enum CodingKeys: String, CodingKey {
        case title, description, week, day
        case programId = "program_id"
    }
}

struct EditWorkoutRequest: Codable {
    var id: String?
    var title: String
    var description: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title, description
    }
}
