//
//  CreateAccountViewModel.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI
import PhotosUI
import Supabase

final class CreateAccountViewModel: ObservableObject {
    // MARK: Variables
    @Published var profilePicture: UIImage? = nil
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            setImage(selection: imageSelection)
        }
    }
    
    @Published var fullName: String = ""
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    @Published var isSaving = false
    @Published var wasSuccessfullyCreated = false
    
    @Published var returnedError = false
    @Published var errorMessage: String? = nil
    
    init() {}
    
    // MARK: Set image
    private func setImage(selection: PhotosPickerItem?) {
        guard let selection else {
            return
        }
        
        Task {
            if let data = try? await selection.loadTransferable(type: Data.self) {
                if let uiImage = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.profilePicture = uiImage
                    }
                }
            }
        }
    }
    
    // MARK: Create user
    @MainActor
    public func createUser() async {
        isSaving = true
        
        let createUserRequest = CreateUserRequest(
            profile_picture: self.profilePicture,
            full_name: self.fullName,
            username: self.username,
            email: self.email,
            password: self.password
        )
        
        do {
            // Check if username is available
            let usernameAvailable = await UserService.shared.checkUsername(username: createUserRequest.username)
            
            if usernameAvailable {
                try await AuthService.shared.createUser(email: createUserRequest.email, password: createUserRequest.password)
                
                let currentUser = try await SupabaseService.shared.supabase.auth.user()
                
                var user = User(
                    id: currentUser.id.description,
                    email: createUserRequest.email,
                    fullName: createUserRequest.full_name,
                    username: createUserRequest.username,
                    paymentsEnabled: false
                )
                
                if createUserRequest.profile_picture != nil {
                    let profilePicturePath = "\(currentUser.id.description)\(Date().hashValue).jpg"
                    
                    guard let imageData = createUserRequest.profile_picture!.pngData() else {
                        print("Couldn't get data from image.")
                        return
                    }
                    
                    let profilePictureUrl = try await StorageService.shared.saveFile(file: imageData, bucketName: "profile_pictures", fileName: profilePicturePath)
                    
                    user.profilePictureUrl = profilePictureUrl
                    user.profilePicturePath = profilePicturePath
                }
                
                try await UserService.shared.createUser(user: user)
                
                UserService.currentUser = user
                wasSuccessfullyCreated = true
                isSaving = false
            } else {
                self.isSaving = false
                self.returnedError = true
                self.errorMessage = "Username is already taken."
            }
        } catch {
            self.isSaving = false
            self.returnedError = true
            self.errorMessage = error.localizedDescription
        }
    }
}
