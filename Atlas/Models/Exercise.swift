//
//  Exercise.swift
//  Atlas
//
//  Created by Michael Bautista on 6/13/24.
//

import SwiftUI

struct Exercise: Codable, Identifiable, Hashable {
    var id: String
    var createdAt: String
    var createdBy: String
    
    var title: String
    var instructions: String?
    
    var videoUrl: String?
    var videoPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case createdBy = "created_by"
        
        case title
        case instructions
        
        case videoUrl = "video_url"
        case videoPath = "video_path"
    }
}

struct FetchedExercise: Codable, Hashable, Identifiable {
    var id: String
    var title: String
    var instructions: String?
    var videoUrl: String?
    var videoPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title, instructions
        case videoUrl = "video_url"
        case videoPath = "video_path"
    }
}

struct NewWorkoutExercise: Codable {
    var programWorkoutId: String?
    var workoutId: String?
    var exerciseId: String
    var exerciseNumber: Int
    var sets: Int
    var reps: Int
    var time: String?
    var other: String?
    
    enum CodingKeys: String, CodingKey {
        case sets, reps, time, other
        case programWorkoutId = "program_workout_id"
        case workoutId = "workout_id"
        case exerciseId = "exercise_id"
        case exerciseNumber = "exercise_number"
    }
}

struct CreateExerciseRequest: Codable {
    var title: String
    var instructions: String?
    var videoUrl: String?
    var videoPath: String?
    
    enum CodingKeys: String, CodingKey {
        case title, instructions
        case videoUrl = "video_url"
        case videoPath = "video_path"
    }
}

struct EditLibraryExerciseRequest: Codable {
    var id: String
    var title: String
    var instructions: String?
    var videoUrl: String?
    var videoPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title, instructions
        case videoUrl = "video_url"
        case videoPath = "video_path"
    }
}

struct EditWorkoutExerciseRequest: Codable {
    var id: String
    var sets: Int
    var reps: Int
    var time: String?
    var other: String?
    
    enum CodingKeys: String, CodingKey {
        case id, sets, reps, time, other
    }
}
