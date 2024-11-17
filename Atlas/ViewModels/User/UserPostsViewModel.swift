//
//  UesrPostsViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 11/7/24.
//

import SwiftUI

final class UserPostsViewModel: ObservableObject {
    // MARK: Variables
    @Published var isLoading = true
    
    @Published var offset = 0
    @Published var endReached = false
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage: String? = nil
    
    @Published var posts = [Post]()
    
    var userId: String
    
    init(userId: String) {
        self.userId = userId
        
        Task {
            await getUserPosts()
        }
    }
    
    @MainActor
    public func pulledRefresh() async {
        self.posts = [Post]()
        self.endReached = false
        
        await getUserPosts()
    }
    
    @MainActor
    public func getUserPosts() async {
        do {
            let posts = try await PostService.shared.getCreatorsPosts(userId: self.userId, offset: offset)

            self.posts.append(contentsOf: posts)
            
            if posts.count < 10 {
                self.endReached = true
            } else {
                offset += 10
            }
            
            self.isLoading = false
        } catch {
            self.isLoading = false
            self.didReturnError = true
            self.returnedErrorMessage = error.localizedDescription
        }
    }
}

