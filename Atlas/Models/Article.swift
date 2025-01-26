//
//  Article.swift
//  Atlas
//
//  Created by Michael Bautista on 1/23/25.
//

import SwiftUI

struct Article: Identifiable, Codable, Hashable {
    var id: String
    var title: String
    var content: String
    var free: Bool
    var imageUrl: String?
    var imagePath: String?
    var users: ArticleUser?
    
    enum CodingKeys: String, CodingKey {
        case id, title, content, free, users
        
        case imageUrl = "image_url"
        case imagePath = "image_path"
    }
}

struct ArticleUser: Codable, Hashable {
    var id: String
    var fullName: String
    var username: String
    
    enum CodingKeys: String, CodingKey {
        case id, username
        case fullName = "full_name"
    }
}
