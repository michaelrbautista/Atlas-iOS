//
//  Program.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI

// MARK: Models
struct Program: Codable, Identifiable, Hashable {
    var id: String
    var createdAt: String
    var createdBy: String
    
    var title: String
    var description: String?
    
    var free: Bool
    var price: Int
    var currency: String
    
    var weeks: Int
    
    var isPrivate: Bool
    
    var imageUrl: String?
    var imagePath: String?
    
    var workouts: [FetchedProgramWorkout]?
    var users: FetchedUser?
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case createdBy = "created_by"
        
        case title
        case description
        
        case free
        case price
        case currency
        
        case weeks
        
        case isPrivate = "private"
        
        case imageUrl = "image_url"
        case imagePath = "image_path"
        
        case workouts
        case users
    }
}

// Reference to a program saved by a user
struct PurchasedProgram: Codable, Identifiable, Hashable {
    var id: String?
    
    // Reference to program
    var programId: String
    
    // User that saved the program
    var purchasedBy: String
    var createdBy: String
    
    var users: FetchedPurchasedProgramUser?
    var programs: FetchedProgram?
    
    enum CodingKeys: String, CodingKey {
        case id
        
        case programId = "program_id"
        
        case purchasedBy = "purchased_by"
        case createdBy = "created_by"
        
        case users
        case programs
    }
}

struct FetchedUser: Codable, Hashable {
    var fullName: String
    
    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
    }
}

struct FetchedPurchasedProgramUser: Codable, Hashable {
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
    var price: Int?
    var weeks: Int
    var free: Bool
    var isPrivate: Bool
}

struct EditProgramRequest: Codable {
    var programId: String
    var title: String
    var description: String?
    var imageUrl: String?
    var imagePath: String?
    var price: Int?
    var weeks: Int
    var free: Bool
    var isPrivate: Bool
}
