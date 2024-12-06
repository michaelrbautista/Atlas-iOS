//
//  FetchTypes.swift
//  Atlas
//
//  Created by Michael Bautista on 11/27/24.
//

struct FetchedPurchasedProgram: Identifiable, Codable, Hashable {
    var id: String
    var createdBy: FetchedUsername?
    var programs: FetchedPurchasedProgramForeignKey?
    
    enum CodingKeys: String, CodingKey {
        case id, programs
        case createdBy = "created_by"
    }
}

struct FetchedPurchasedProgramForeignKey: Identifiable, Codable, Hashable {
    var id: String
    var title: String
    var price: Int
    var imageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title, price
        case imageUrl = "image_url"
    }
}

struct FetchedUsername: Codable, Hashable {
    var fullName: String
    
    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
    }
}

struct FetchedProgram: Identifiable, Codable, Hashable {
    var id: String
    var title: String
    var description: String?
    var imageUrl: String?
    var price: Int
    var weeks: Int
    var free: Bool
    var isPrivate: Bool
    var createdBy: FetchedUsername?
    
    enum CodingKeys: String, CodingKey {
        case id, title, description, price, weeks, free
        case imageUrl = "image_url"
        case isPrivate = "private"
        case createdBy = "created_by"
    }
}

struct FetchedProgramWorkout: Codable, Hashable, Identifiable {
    var id: String
    var title: String
    var description: String?
    
    var programExercises: [FetchedProgramExercise]?
    
    enum CodingKeys: String, CodingKey {
        case id, title, description
        case programExercises = "program_exercises"
    }
}

struct FetchedWorkout: Codable, Hashable, Identifiable {
    var id: String
    var title: String
    var description: String
    
    var programExercises: [FetchedProgramExercise]?
    
    enum CodingKeys: String, CodingKey {
        case id, title, description
        case programExercises = "program_exercises"
    }
}

struct FetchedProgramExercise: Codable, Hashable, Identifiable {
    var id: String
    var exerciseNumber: Int
    var sets: Int?
    var reps: Int?
    var time: String?
    
    var exercises: FetchedExercise?
    
    enum CodingKeys: String, CodingKey {
        case id, sets, reps, time, exercises
        case exerciseNumber = "exercise_number"
    }
}

struct FetchedExercise: Codable, Hashable, Identifiable {
    var id: String
    var title: String
    var instructions: String?
    var videoUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title, instructions
        case videoUrl = "video_url"
    }
}
