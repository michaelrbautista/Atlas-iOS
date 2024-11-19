//
//  HomeViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 10/7/24.
//

import SwiftUI

final class HomeViewModel: ObservableObject {
    
    @Published var isLoading = false
    
    @Published var posts = [Post]()
    
    @Published var offset = 0
    @Published var endReached = false
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage = ""
    
    init() {
        self.isLoading = true
        
        Task {
            await getPosts()
        }
    }
    
    @MainActor
    public func getPosts() async {
        do {
            let posts = try await PostService.shared.getAllPosts(offset: offset)
            
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
