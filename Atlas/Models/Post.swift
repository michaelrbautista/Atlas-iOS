//
//  Post.swift
//  Atlas
//
//  Created by Michael Bautista on 11/1/24.
//

import SwiftUI

// MARK: Models
struct Post: Codable, Identifiable, Hashable {
    var id: String
    var createdAt: String
    var createdBy: String
    
    var text: String?
    
    var workoutId: String?
    var programId: String?
    
    var users: FetchedUser?
    var workouts: FetchedWorkout?
    var programs: FetchedProgram?
    
    func calculateDate() -> String {
        let postDate = createdAt.components(separatedBy: "+")[0].components(separatedBy: ".")[0]
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let swiftDate = dateFormatter.date(from: postDate)!
        
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        let string = formatter.localizedString(for: swiftDate, relativeTo: Date())
        
        return string
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case createdBy = "created_by"
        
        case text
        
        case workoutId = "workout_id"
        case programId = "program_id"
        
        case users
        case workouts
        case programs
    }
}
