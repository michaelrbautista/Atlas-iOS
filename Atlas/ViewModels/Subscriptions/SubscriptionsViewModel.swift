//
//  SubscriptionsViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 1/13/25.
//

import SwiftUI

final class SubscriptionsViewModel: ObservableObject {
    // MARK: Variables
    @Published var isLoading = true
    
    @Published var offset = 0
    @Published var endReached = false
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage = ""
    
    @Published var subscriptions = [Subscription]()
    
    var userId: String
    
    // MARK: Initializaer
    init() {
        guard let currentUserId = UserService.currentUser?.id.description else {
            userId = ""
            self.didReturnError = true
            self.returnedErrorMessage = "Couldn't get current user."
            return
        }
        
        self.userId = currentUserId
        
        Task {
            await getSubscriptions()
        }
    }
    
    // MARK: Refresh
    @MainActor
    public func pulledRefresh() async {
        self.subscriptions = [Subscription]()
        
        await getSubscriptions()
    }
    
    // MARK: Get my saved programs
    @MainActor
    public func getSubscriptions() async {
        do {
            let subscriptions = try await SubscriptionService.shared.getSubscriptions(userId: self.userId, offset: offset)
            
            self.subscriptions.append(contentsOf: subscriptions)
            
            if subscriptions.count < 10 {
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
