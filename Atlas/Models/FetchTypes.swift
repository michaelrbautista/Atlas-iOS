//
//  FetchTypes.swift
//  Atlas
//
//  Created by Michael Bautista on 11/27/24.
//

struct FetchedPurchasedProgram: Codable, Hashable, Identifiable {
    var id: String
    var createdBy: FetchedUsername?
    var programs: FetchedProgram?
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdBy = "created_by"
        case programs
    }
}

struct FetchedUsername: Codable, Hashable {
    var fullName: String
    
    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
    }
}

struct FetchedProgram: Codable, Hashable {
    var id: String
    var title: String
    var price: Int
    var description: String?
    var imageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case price
        case description
        case imageUrl = "image_url"
    }
}

struct FetchedProgramWorkout: Codable, Hashable, Identifiable {
    var id: String
    var title: String
    var description: String?
    
    var programExercises: [FetchedProgramExercise]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        
        case programExercises = "program_exercises"
    }
}

struct FetchedProgramExercise: Codable, Hashable, Identifiable {
    var id: String
    var exerciseId: String
    var exerciseNumber: Int
    var sets: Int?
    var reps: Int?
    var time: String?
    var exercises: FetchedExercise?
    
    enum CodingKeys: String, CodingKey {
        case id
        case exerciseId = "exercise_id"
        case exerciseNumber = "exercise_number"
        case sets
        case reps
        case time
        case exercises
    }
}

struct FetchedExercise: Codable, Hashable {
    var title: String
    var instructions: String?
    var videoUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case instructions
        case videoUrl = "video_url"
    }
}
