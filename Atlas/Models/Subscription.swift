//
//  Subscription.swift
//  Atlas
//
//  Created by Michael Bautista on 1/13/25.
//

import SwiftUI

struct Subscription: Identifiable, Codable, Hashable {
    var id: String
    var subscriber: String
    var subscribedTo: FetchedSubscriptionUser?
    var tier: String
    var stripeSubscriptionId: String
    var stripeCustomerId: String
    var stripePriceId: String
    var isActive: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, subscriber, tier
        case subscribedTo = "subscribed_to"
        case stripeSubscriptionId = "stripe_subscription_id"
        case stripeCustomerId = "stripe_customer_id"
        case stripePriceId = "stripe_price_id"
        case isActive = "is_active"
    }
}

struct FetchedSubscriptionUser: Codable, Hashable {
    var id: String
    var fullName: String
    var username: String
    var profilePictureUrl: String?
    var bio: String?
    
    enum CodingKeys: String, CodingKey {
        case id, username, bio
        case fullName = "full_name"
        case profilePictureUrl = "profile_picture_url"
    }
}

struct CheckSubscription: Codable, Hashable {
    var id: String
}
