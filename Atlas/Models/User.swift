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
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        
        case email
        case fullName = "full_name"
        case username
        
        case bio
        
        case profilePictureUrl = "profile_picture_url"
        case profilePicturePath = "profile_picture_path"
        
        case stripeAccountId = "stripe_account_id"
        case paymentsEnabled = "payments_enabled"
        case stripePriceId = "stripe_price_id"
    }
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
