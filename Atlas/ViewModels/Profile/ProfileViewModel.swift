//
//  ProfileViewModel.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI
import FirebaseFirestore

final class ProfileViewModel: ObservableObject {
    
    // MARK: Variables
    @Published var isLoading = false
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage = ""
    
    @Published var userImage: UIImage? = nil
    @Published var userImageIsLoading = false
    
    @Published var user: User?
    
    init() {
        isLoading = true
        
        guard let currentUser = UserService.currentUser else {
            self.didReturnError = true
            self.returnedErrorMessage = "Couldn't get current user."
            return
        }
        
        self.user = currentUser
        
        if user!.userImageUrl != "" {
            self.userImageIsLoading = true
            
            self.getUserImage(imageUrl: user!.userImageUrl) { error in
                self.isLoading = false
                
                if let error = error {
                    self.didReturnError = true
                    self.returnedErrorMessage = error.localizedDescription
                    return
                }
                
                self.userImageIsLoading = false
            }
        } else {
            isLoading = false
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
    
    // MARK: Update user
//    public func updateUser(completion: @escaping (_ newUser: User?, _ error: Error?) -> Void) {
//        self.isLoading = true
//        
//        if user != nil {
//            UserService.shared.updateUser(user: user!, uid: user!.uid) { error in
//                self.isLoading = false
//                
//                if let error = error {
//                    self.didReturnError = true
//                    self.returnedErrorMessage = error.localizedDescription
//                    return
//                }
//            }
//        } else {
//            self.isLoading = false
//            
//            self.didReturnError = true
//            self.returnedErrorMessage = "Error saving user."
//            return
//        }
//    }
    
}
