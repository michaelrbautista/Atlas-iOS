//
//  ProgramSection.swift
//  Atlas
//
//  Created by Michael Bautista on 6/13/24.
//

import SwiftUI

struct ProgramSection: Codable, Identifiable, Hashable {
    var id: String?
    var createdAt: String?
    var createdBy: String
    
    var programId: String
    
    var sectionNumber: Int
    
    var title: String
    var description: String
    
    var workouts: [Workout]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case createdBy = "created_by"
        
        case programId = "program_id"
        
        case sectionNumber = "section_number"
        
        case title
        case description
        
        case workouts
    }
}
