//
//  CreateAccountViewModel.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI
import PhotosUI

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
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage: String? = nil
    
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
    public func createUser(completion: @escaping (_ wasCreated: Bool?, _ errorMessage: String?, _ error: Error?) -> Void) async {
        if email == "" || password == "" || confirmPassword == "" || fullName == "" || username == "" {
            completion(false, "Please fill in all fields.", nil)
            return
        }
        
        if !Validator.validateUsernameRegex(for: username) {
            completion(false, "Username must be at least 4 characters and cannot contain special characters.", nil)
            return
        }
        
        if !Validator.validateEmail(for: email) {
            completion(false, "Please enter a valid email.", nil)
            return
        }
        
        if !Validator.validatePassword(for: password) {
            completion(false, "Your password must have at least 8 characaters, including a number and a special character.", nil)
            return
        }
        
        if password != confirmPassword {
            completion(false, "Please make sure both passwords are the same.", nil)
            return
        }
        
        let createUserRequest = CreateUserRequest(
            profilePicture: self.profilePicture,
            fullName: self.fullName,
            username: self.username,
            email: self.email,
            password: self.password
        )
        
        await AuthService.shared.createUser(createUserRequest: createUserRequest) { wasCreated, error in
            if let error = error {
                completion(false, nil, error)
                return
            }
            
            completion(true, nil, nil)
            return
        }
    }
    
}
