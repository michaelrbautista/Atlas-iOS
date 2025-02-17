//
//  UserService.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI
import Supabase

class UserService {
    
    public static let shared = UserService()
    public static var currentUser: User? = nil
    
    // MARK: Get all users
    public func getAllUsers() async throws -> [User] {
        do {
            #if DEBUG
            let users: [User] = try await SupabaseService.shared.supabase
                .from("users")
                .select(
                    """
                        id,
                        email,
                        full_name,
                        username,
                        bio,
                        profile_picture_url,
                        profile_picture_path,
                        stripe_account_id,
                        payments_enabled,
                        stripe_price_id
                    """
                )
                .neq("stripe_price_id", value: "null")
                .execute()
                .value
            #else
            let users: [User] = try await SupabaseService.shared.supabase
                .from("users")
                .select(
                    """
                        id,
                        email,
                        full_name,
                        username,
                        bio,
                        profile_picture_url,
                        profile_picture_path,
                        stripe_account_id,
                        payments_enabled,
                        stripe_price_id
                    """
                )
                .neq("stripe_price_id", value: "null")
                .neq("id", value: "e4d6f88c-d8c3-4a01-98d6-b5d56a366491")
                .execute()
                .value
            #endif
            
            return users
        } catch {
            throw error
        }
    }
    
    // MARK: Search users
    public func searchUsers(searchText: String) async throws -> [User] {
        do {
            let users: [User] = try await SupabaseService.shared.supabase
                .from("users")
                .select(
                    """
                        id,
                        email,
                        full_name,
                        username,
                        bio,
                        profile_picture_url,
                        profile_picture_path,
                        stripe_account_id,
                        payments_enabled,
                        stripe_price_id
                    """
                )
                .textSearch("full_name", query: "'\(searchText)'")
                .execute()
                .value
            
            return users
        } catch {
            throw error
        }
    }
    
    // MARK: Create user
    public func createUser(user: User) async throws {
        do {
            try await SupabaseService.shared.supabase
                .from("users")
                .insert(user)
                .execute()
        } catch {
            print("Error creating user in database")
            throw error
        }
    }
    
    // MARK: Get user
    public func getUser(uid: String) async throws -> User {
        do {
            let user: User = try await SupabaseService.shared.supabase
                .from("users")
                .select(
                    """
                        id,
                        email,
                        full_name,
                        username,
                        bio,
                        profile_picture_url,
                        profile_picture_path,
                        stripe_account_id,
                        payments_enabled,
                        stripe_price_id,
                        collections(
                            id,
                            title,
                            description
                        )
                    """
                )
                .eq("id", value: uid)
                .single()
                .execute()
                .value
            
            return user
        } catch {
            print("Couldn't get user")
            throw error
        }
    }
    
    // MARK: Check if username exists
    public func checkUsername(username: String) async -> Bool {
        do {
            let count = try await SupabaseService.shared.supabase
                .from("users")
                .select("*", head: true, count: .exact)
                .eq("username", value: username)
                .execute()
                .count
            
            if let usernameCount = count {
                if usernameCount > 0 {
                    return false
                } else {
                    return true
                }
            } else {
                return false
            }
        } catch {
            print("Error checking username")
            print(error.localizedDescription)
            return false
        }
    }
    
    // MARK: Delete user
    public func deleteUser(uid: String) async throws {
        do {
            try await SupabaseService.shared.supabase.rpc("delete_user")
            .execute()
        } catch {
            throw error
        }
    }
    
}
