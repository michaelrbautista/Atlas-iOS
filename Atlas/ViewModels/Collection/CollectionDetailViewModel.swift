//
//  CollectionDetailViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 1/23/25.
//

import SwiftUI

final class CollectionDetailViewModel: ObservableObject {
    
    // MARK: Variables
    var collection: Collection? = nil
    
    @Published var isLoading = true
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage = ""
    
    var collectionId: String
    
    // MARK: Initializer
    init(collectionId: String) {
        self.collectionId = collectionId
    }
    
    // MARK: Get collection
    @MainActor
    public func getCollection() async {
        Task {
            do {
                // Get program
                let collection = try await CollectionService.shared.getCollection(collectionId: collectionId)
                
                let currentUserId = UserService.currentUser?.id
                
                self.collection = collection
                
                self.isLoading = false
            } catch {
                self.isLoading = false
                self.didReturnError = true
                self.returnedErrorMessage = error.localizedDescription
            }
        }
    }
}
