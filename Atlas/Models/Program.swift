//
//  Program.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI

struct Program: Identifiable, Codable, Hashable {
    var id: String
    var title: String
    var description: String?
    var imageUrl: String?
    var imagePath: String?
    var price: Double
    var weeks: Int
    var free: Bool
    var isPrivate: Bool
    var createdBy: FetchedUser?
    
    enum CodingKeys: String, CodingKey {
        case id, title, description, price, weeks, free
        case imageUrl = "image_url"
        case imagePath = "image_path"
        case isPrivate = "private"
        case createdBy = "created_by"
    }
}

struct ProgramWorkout: Codable, Hashable, Identifiable {
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

struct PurchasedProgram: Identifiable, Codable, Hashable {
    var id: String
    var createdBy: FetchedUser?
    var programs: PurchasedProgramForeignKey?
    
    enum CodingKeys: String, CodingKey {
        case id, programs
        case createdBy = "created_by"
    }
}

struct PurchasedProgramForeignKey: Identifiable, Codable, Hashable {
    var id: String
    var title: String
    var price: Double
    var imageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title, price
        case imageUrl = "image_url"
    }
}

struct PurchasedProgramUser: Codable, Hashable {
    var fullName: String
    
    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
    }
}

struct CreateProgramRequest: Codable {
    var title: String
    var description: String?
    var imageUrl: String?
    var imagePath: String?
    var price: Double?
    var weeks: Int
    var free: Bool
    var isPrivate: Bool
    
    enum CodingKeys: String, CodingKey {
        case title, description, price, weeks, free
        case imageUrl = "image_url"
        case imagePath = "image_path"
        case isPrivate = "private"
    }
}

struct PurchaseProgramRequest: Codable {
    var programId: String
    var createdBy: String
    
    enum CodingKeys: String, CodingKey {
        case programId = "program_id"
        case createdBy = "created_by"
    }
}

struct EditProgramRequest: Codable {
    var id: String
    var title: String
    var description: String?
    var imageUrl: String?
    var imagePath: String?
    var price: Double?
    var weeks: Int
    var free: Bool
    var isPrivate: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, title, description, price, weeks, free
        case imageUrl = "image_url"
        case imagePath = "image_path"
        case isPrivate = "private"
    }
}

struct ProgramId: Codable {
    var id: String
}
