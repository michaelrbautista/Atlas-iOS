//
//  ArticleDetailViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 1/23/25.
//

import SwiftUI

final class ArticleDetailViewModel: ObservableObject {
    
    @Published var isLoading = true
    
    @Published var isCreator = false
    @Published var isSubscribed = false
    
    @Published var articleImage: UIImage? = nil
    @Published var articleImageIsLoading = true
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage = ""
    
    var article: Article
    var jsonContent: NSArray = []
    
    // MARK: Initializer
    init(article: Article) {
        self.article = article
        
        decodeContent()
    }
    
    public func decodeContent() {
        guard let jsonData = article.content.data(using: .utf8) else {
            print("Couldn't decode JSON")
            return
        }
        
        do {
            // Decode JSON into a dictionary
            guard let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
                print("Couldn't serialize JSON")
                return
            }
            
            guard let docContent = jsonDict["content"] as? NSArray else {
                print("Couldn't get tiptap content.")
                return
            }
            
            self.jsonContent = docContent
        } catch {
            print("Error decoding JSON: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    public func checkSubscription() async {
        guard let currentUserId = UserService.currentUser?.id, let creatorId = article.users?.id else {
            return
        }
        self.isCreator = creatorId == currentUserId
        
        do {
            if !self.isCreator {
                // Check if subscribed
                let checkIsSubscribed = try await SubscriptionService.shared.checkSubscription(userId: currentUserId, creatorId: creatorId)
                self.isSubscribed = checkIsSubscribed
                
                self.isLoading = false
            }
            
            // Get image
            if let imageUrl = article.imageUrl {
                try await self.getArticleImage(imageUrl: imageUrl)
            } else {
                self.articleImageIsLoading = false
                self.articleImage = UIImage(systemName: "figure.run")
            }
        } catch {
            self.isLoading = false
            self.didReturnError = true
            self.returnedErrorMessage = error.localizedDescription
        }
    }
    
    // MARK: Get article image
    @MainActor
    public func getArticleImage(imageUrl: String) async throws {
        self.articleImageIsLoading = true
        
        guard let imageUrl = URL(string: imageUrl) else {
            self.articleImageIsLoading = false
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: imageUrl)
            
            guard let image = UIImage(data: data) else {
                return
            }
            
            self.articleImageIsLoading = false
            self.articleImage = image
        } catch {
            throw error
        }
    }
}
