//
//  CollectionService.swift
//  Atlas
//
//  Created by Michael Bautista on 1/23/25.
//

import SwiftUI

final class CollectionService {
    
    public static let shared = CollectionService()
    
    // MARK: Get collection
    public func getCollection(collectionId: String) async throws -> Collection {
        do {
            let collection: Collection = try await SupabaseService.shared.supabase
                .from("collections")
                .select(
                    """
                        id,
                        title,
                        description,
                        articles(
                            id,
                            collection_id,
                            title,
                            content,
                            free,
                            image_url,
                            image_path,
                            users(
                                id,
                                full_name,
                                username
                            )
                        )
                    """
                )
                .eq("id", value: collectionId)
                .order("created_at", ascending: false)
                .single()
                .execute()
                .value
            
            return collection
        } catch {
            print(error)
            throw error
        }
    }
    
    // MARK: Get creator's collections
    public func getCreatorsCollections(userId: String, offset: Int) async throws -> [Collection] {
        do {
            let collections: [Collection] = try await SupabaseService.shared.supabase
                .from("collections")
                .select(
                    """
                        id,
                        title,
                        description
                    """
                )
                .eq("created_by", value: userId)
                .order("collection_number", ascending: false)
                .range(from: offset, to: offset + 9)
                .execute()
                .value
            
            return collections
        } catch {
            throw error
        }
    }
    
}
