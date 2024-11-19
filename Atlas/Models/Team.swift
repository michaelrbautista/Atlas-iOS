//
//  Team.swift
//  Atlas
//
//  Created by Michael Bautista on 9/8/24.
//

import SwiftUI

struct Team: Codable, Identifiable, Hashable {
    var id: String
    var createdAt: String
    var createdBy: String
    
    var name: String
    var description: String?
    
    var imageUrl: String?
    var imagePath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case createdBy = "created_by"
        
        case name
        case description
        
        case imageUrl = "image_url"
        case imagePath = "image_path"
    }
}

struct JoinedTeam: Codable, Identifiable, Hashable {
    var id: String?
    var createdAt: String?
    
    var userId: String
    var teamId: String
    
    var tier: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        
        case userId = "user_id"
        case teamId = "team_id"
        
        case tier
    }
}
