//
//  Collection.swift
//  Atlas
//
//  Created by Michael Bautista on 1/23/25.
//

import SwiftUI

struct Collection: Identifiable, Codable, Hashable {
    var id: String
    var title: String
    var description: String?
    var articles: [Article]?
    
    enum CodingKeys: String, CodingKey {
        case id, title, description, articles
    }
}
