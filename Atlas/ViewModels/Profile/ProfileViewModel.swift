//
//  ProfileViewModel.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI

final class ProfileViewModel: ObservableObject {
    
    // MARK: Variables
    @Published var isLoading = false
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage = ""
    
    @Published var profilePicture: UIImage? = nil
    @Published var profilePictureIsLoading = false
    
    var user: User?
    
    init() {
        isLoading = true
        
        guard let currentUser = UserService.currentUser else {
            self.didReturnError = true
            self.returnedErrorMessage = "Couldn't get current user."
            return
        }
        
        self.user = currentUser
        
        self.isLoading = false
        
        if user!.profilePictureUrl != nil {
            self.profilePictureIsLoading = true
            
            self.getUserImage(imageUrl: user!.profilePictureUrl!) { error in
                if let error = error {
                    self.didReturnError = true
                    self.returnedErrorMessage = error.localizedDescription
                    return
                }
                
                self.profilePictureIsLoading = false
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
    
}
