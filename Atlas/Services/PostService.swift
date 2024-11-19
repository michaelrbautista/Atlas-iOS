//
//  PostService.swift
//  Atlas
//
//  Created by Michael Bautista on 11/1/24.
//

import SwiftUI

final class PostService {
    
    public static let shared = PostService()
    
    // MARK: Get creator's posts
    public func getCreatorsPosts(userId: String, offset: Int) async throws -> [Post] {
        do {
            let posts: [Post] = try await SupabaseService.shared.supabase
                .from("posts")
                .select(
                    """
                        *,
                        users (
                            id,
                            full_name,
                            profile_picture_url
                        ),
                        workouts (
                            id,
                            title,
                            description
                        ),
                        programs (
                            id,
                            title,
                            price,
                            description,
                            image_url
                        )
                    """
                )
                .eq("created_by", value: userId)
                .order("created_at", ascending: false)
                .range(from: offset, to: offset + 9)
                .execute()
                .value
            
            return posts
        } catch {
            throw error
        }
    }
    
    // MARK: Get all posts
    public func getAllPosts(offset: Int) async throws -> [Post] {
        do {
            let posts: [Post] = try await SupabaseService.shared.supabase
                .from("posts")
                .select(
                    """
                        *,
                        users (
                            id,
                            full_name,
                            profile_picture_url
                        ),
                        workouts (
                            id,
                            title,
                            description
                        ),
                        programs (
                            id,
                            title,
                            price,
                            description,
                            image_url
                        )
                    """
                )
                .order("created_at", ascending: false)
                .range(from: offset, to: offset + 9)
                .execute()
                .value
            
            return posts
        } catch {
            throw error
        }
    }
    
}
