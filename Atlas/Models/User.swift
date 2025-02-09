//
//  User.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI

struct User: Codable, Identifiable, Hashable {
    var id: String
    var createdAt: String?
    
    var email: String
    var fullName: String
    var username: String
    
    var bio: String?
    
    var profilePictureUrl: String?
    var profilePicturePath: String?
    
    var stripeAccountId: String?
    var paymentsEnabled: Bool
    var stripePriceId: String?
    
    var collections: [UserCollection]?
    
    enum CodingKeys: String, CodingKey {
        case id, email, username, bio, collections
        case createdAt = "created_at"
        
        case fullName = "full_name"
        
        case profilePictureUrl = "profile_picture_url"
        case profilePicturePath = "profile_picture_path"
        
        case stripeAccountId = "stripe_account_id"
        case paymentsEnabled = "payments_enabled"
        case stripePriceId = "stripe_price_id"
    }
}

struct UserCollection: Identifiable, Codable, Hashable {
    var id: String
    var title: String
    var description: String?
}

struct FetchedUser: Codable, Hashable {
    var id: String
    var fullName: String
    var username: String
    
    enum CodingKeys: String, CodingKey {
        case id, username
        case fullName = "full_name"
    }
}

// MARK: Requests
struct CreateUserRequest {
    var profile_picture: UIImage?
    var full_name: String
    var username: String
    var email: String
    var password: String
}
