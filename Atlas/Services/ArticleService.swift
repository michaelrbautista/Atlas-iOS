//
//  ArticleService.swift
//  Atlas
//
//  Created by Michael Bautista on 1/23/25.
//

final class ArticleService {
    
    public static let shared = ArticleService()
    
    // MARK: Get creator's collections
    public func getCollectionsArticles(collectionId: String, offset: Int) async throws -> [Article] {
        do {
            let articles: [Article] = try await SupabaseService.shared.supabase
                .from("articles")
                .select(
                    """
                        id,
                        collection_id,
                        title,
                        content,
                        image_url,
                        image_path,
                        free,
                        created_by:users!articles_created_by_fkey(
                            id,
                            full_name,
                            username
                        )
                    """
                )
                .eq("collection_id", value: collectionId)
                .order("created_at", ascending: false)
                .range(from: offset, to: offset + 9)
                .execute()
                .value
            
            return articles
        } catch {
            throw error
        }
    }
    
}
