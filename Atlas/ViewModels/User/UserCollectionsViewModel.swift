//
//  UserCollectionsViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 1/23/25.
//

import SwiftUI

final class UserCollectionsViewModel: ObservableObject {
    // MARK: Variables
    @Published var isLoading = true
    
    @Published var offset = 0
    @Published var endReached = false
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage = ""
    
    @Published var collections = [Collection]()
    
    var userId: String
    
    init(userId: String) {
        self.userId = userId
    }
    
    @MainActor
    public func pulledRefresh() async {
        self.collections = [Collection]()
        
        await getCreatorsCollections()
    }
    
    @MainActor
    public func getCreatorsCollections() async {
        do {
            let collections = try await CollectionService.shared.getCreatorsCollections(userId: self.userId, offset: self.offset)
            
            self.collections.append(contentsOf: collections)
            
            if collections.count < 10 {
                self.endReached = true
            } else {
                self.endReached = false
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
