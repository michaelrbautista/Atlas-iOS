//
//  UserDetailViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 9/9/24.
//

import SwiftUI

final class UserDetailViewModel: ObservableObject {
    
    @Published var isLoading = true
    @Published var isSubscribing = false
    
    @Published var didReturnError = false
    @Published var errorMessage: String? = nil
    
    var userId: String
    @Published var user: User? = nil
    
    @Published var userImage: UIImage? = nil
    @Published var userProfilePictureIsLoading = false
    
    @Published var isCreator = false
    @Published var isSubscribed = false
    
    @Published var pickerValue = "posts"
    
    init(userId: String) {
        self.userId = userId
    }
    
    // MARK: Unsubscribe
    @MainActor
    public func unsubscribeFromUser() async {
        self.isSubscribing = true
        
        guard let currentUserId = UserService.currentUser?.id else {
            self.isSubscribing = false
            self.didReturnError = true
            self.errorMessage = "There was an error getting the current user and creator id."
            return
        }
        
        do {
            try await SubscriptionService.shared.unsubscribe(
                subscriber: currentUserId,
                subscribedTo: userId
            )
            
            self.isSubscribed = false
            self.isSubscribing = false
        } catch {
            self.isSubscribing = false
            self.didReturnError = true
            self.errorMessage = error.localizedDescription
        }
    }
    
    // MARK: Subscribe
    @MainActor
    public func subscribeToUser() async {
        self.isSubscribing = true
        
        do {
            guard let currentUserId = UserService.currentUser?.id else {
                self.isSubscribing = false
                self.didReturnError = true
                self.errorMessage = "There was an error getting the current user and creator id."
                return
            }
            
            // Check if old subscription exists
            let oldSubscription = try await SubscriptionService.shared.getPreviousSubscription(
                subscriber: currentUserId,
                subscribedTo: userId
            )
            
            if oldSubscription.count > 0 {
                try await SubscriptionService.shared.updateOldSubscription(
                    subscriber: currentUserId,
                    subscribedTo: userId
                )
            } else {
                let newSubscription = NewSubscriptionRequest(
                    subscribedTo: userId,
                    tier: "free",
                    isActive: true
                )
                
                try await SubscriptionService.shared.createNewSubscription(newSubscription: newSubscription)
            }
            
            self.isSubscribed = true
            self.isSubscribing = false
        } catch {
            self.isSubscribing = false
            self.didReturnError = true
            self.errorMessage = error.localizedDescription
        }
    }
    
    // MARK: Get user
    @MainActor
    public func getUser(userId: String) async {
        do {
            // Get user
            let user = try await UserService.shared.getUser(uid: userId)
            
            self.user = user
            
            if user.profilePictureUrl != nil {
                self.userProfilePictureIsLoading = true
                
                self.getImage(imageUrl: user.profilePictureUrl!) { error in
                    self.userProfilePictureIsLoading = false
                    
                    if let error = error {
                        self.isLoading = false
                        self.didReturnError = true
                        self.errorMessage = error.localizedDescription
                        return
                    }
                }
            }
            
            // Check if user is creator
            guard let currentUserId = UserService.currentUser?.id else {
                return
            }
            self.isCreator = userId == currentUserId
            
            // Check if user is subscribed
            if !self.isCreator {
                // Check if subscribed
                let checkIsSubscribed = try await SubscriptionService.shared.checkSubscription(userId: currentUserId, creatorId: userId)
                self.isSubscribed = checkIsSubscribed
            }
            
            self.isLoading = false
        } catch {
            self.isLoading = false
            self.didReturnError = true
            self.errorMessage = error.localizedDescription
        }
    }
    
    // MARK: Get user iamge
    public func getImage(imageUrl: String, completion: @escaping (_ error: Error?) -> Void) {
        guard let fetchUrl = URL(string: imageUrl) else {
            print("Couldn't get image from URL.")
            return
        }
        
        let task = URLSession.shared.dataTask(with: fetchUrl) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(error)
                    return
                }
                
                if let data = data, let image = UIImage(data: data) {
                    self.userImage = image
                    completion(nil)
                } else {
                    print("Couldn't get image from data.")
                    return
                }
            }
        }
        
        task.resume()
    }
}
