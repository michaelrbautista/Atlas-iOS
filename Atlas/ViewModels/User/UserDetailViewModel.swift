//
//  UserDetailViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 9/9/24.
//

import SwiftUI

final class UserDetailViewModel: ObservableObject {
    
    @Published var isLoading = true
    
    @Published var didReturnError = false
    @Published var errorMessage: String? = nil
    
    @Published var user: User?
    
    @Published var userImage: UIImage? = nil
    @Published var userProfilePictureIsLoading = false
    
    @Published var pickerValue = "posts"
    
    init(userId: String) {
        Task {
            await getUser(userId: userId)
        }
    }
    
    @MainActor
    public func getUser(userId: String) async {
        do {
            let user = try await UserService.shared.getUser(uid: userId)
            
            self.user = user
            
            if user.profilePictureUrl != nil {
                self.userProfilePictureIsLoading = true
                
                self.getImage(imageUrl: user.profilePictureUrl!) { error in
                    self.userProfilePictureIsLoading = false
                    
                    if let error = error {
                        self.didReturnError = true
                        self.errorMessage = error.localizedDescription
                        return
                    }
                }
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
