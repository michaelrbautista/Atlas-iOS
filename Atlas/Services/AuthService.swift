//
//  AuthService.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import UIKit
import Supabase

final class AuthService {
    
    public static let shared = AuthService()
    private init() {}
    
    // MARK: Create user
    public func createUser(email: String, password: String) async throws {
        do {
            try await SupabaseService.shared.supabase.auth.signUp(
                email: email,
                password: password
            )
        } catch {
            print("Error creating user in auth")
            throw error
        }
    }
    
    // MARK: Sign in
    public func signIn(email: String, password: String) async throws {
        do {
            try await SupabaseService.shared.supabase.auth.signIn(
                email: email,
                password: password
            )
        } catch {
            throw error
        }
    }
    
}
