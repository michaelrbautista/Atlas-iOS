//
//  User.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI
import Firebase

struct User: Codable {
    var uid: String
    var fullName: String
    var fullNameLowercase: String
    var userImageUrl: String = ""
    var userImagePath: String = ""
    var username: String
    var email: String
}

// MARK: Requests
struct CreateUserRequest {
    var userImage: UIImage?
    var fullName: String
    var username: String
    var email: String
    var password: String
}

struct UpdateUserRequest {
    var userImage: UIImage?
    var username: String
    var fullName: String
}
