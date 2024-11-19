//
//  PostDetailViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 11/3/24.
//

import SwiftUI

final class PostDetailViewModel: ObservableObject {
    
    @Published var isLoading = false
    
    var post: Post
    
    init(post: Post) {
        self.post = post
    }
    
    public func getPost() async {
        
    }
    
}
