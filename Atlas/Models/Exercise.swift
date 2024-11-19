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
