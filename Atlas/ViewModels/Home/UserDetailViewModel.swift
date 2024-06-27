//
//  UserDetailViewModel.swift
//  stayhard
//
//  Created by Michael Bautista on 3/26/24.
//

import SwiftUI

final class UserDetailViewModel: ObservableObject {
    
    // MARK: Variables
    @Published var didReturnError = false
    @Published var returnedErrorMessage: String? = nil
    
    var user: User
    
    @Published var profilePicture: UIImage? = nil
    @Published var profilePictureIsLoading = false
    
    init(user: User) {
        self.user = user
        
        if user.profilePictureUrl != nil {
            self.profilePictureIsLoading = true
            
            self.getUserImage(imageUrl: user.profilePictureUrl!) { error in
                self.profilePictureIsLoading = false
                
                if let error = error {
                    self.didReturnError = true
                    self.returnedErrorMessage = error.localizedDescription
                    return
                }
            }
        }
    }
    
    // MARK: Get user iamge
    public func getUserImage(imageUrl: String, completion: @escaping (_ error: Error?) -> Void) {
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
                    self.profilePicture = image
                    completion(nil)
                } else {
                    print("Couldn't get image from data.")
                    return
                }
            }
        }
        
        task.resume()
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
