//
//  HomeViewModel.swift
//  stayhard
//
//  Created by Michael Bautista on 3/26/24.
//

import SwiftUI
import FirebaseFirestore

final class HomeViewModel: ObservableObject {
    
    // MARK: Variables
    @Published var isLoading = false
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage: String? = nil
    
    @Published var user: User?
    
    init(uid: String) {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        // MARK: Get Luke's user profile
        Task {
            await UserService.shared.getUser(uid: uid) { user, error in
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                
                if let error = error {
                    self.didReturnError = true
                    self.returnedErrorMessage = error.localizedDescription
                    return
                }
                
                DispatchQueue.main.async {
                    self.user = user
                }
            }
        }
    }
    
    public func pulledRefresh() {
//        self.user = nil
        
//        isLoading = true
        
//        guard let currentUserUid = UserService.currentUser?.uid else {
//            didReturnError = true
//            returnedErrorMessage = "Error getting workouts."
//            return
//        }
        
        // MARK: Get Luke's profile
    }
    
}
