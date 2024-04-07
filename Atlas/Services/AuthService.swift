//
//  AuthService.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import FirebaseAuth

final class AuthService {
    
    public static let shared = AuthService()
    public static let db = Firestore.firestore()
    private init() {}
    
    // MARK: Create user
    public func createUser(createUserRequest: CreateUserRequest, completion: @escaping (_ wasCreated: Bool, _ error: Error?) -> Void) async {
        await UserService.shared.checkUsername(username: createUserRequest.username) { available, error in
            if let error = error {
                completion(false, error)
                return
            }
            
            if available == false {
                completion(false, nil)
                return
            }
            
            Auth.auth().createUser(withEmail: createUserRequest.email, password: createUserRequest.password) { result, error in
                if let error = error {
                    completion(false, error)
                    return
                }
                
                guard let uid = result?.user.uid else {
                    completion(false, nil)
                    return
                }
                
                var user = User(
                    uid: uid,
                    fullName: createUserRequest.fullName,
                    fullNameLowercase: createUserRequest.fullName.lowercased(),
                    username: createUserRequest.username,
                    email: createUserRequest.email
                )
                
                let imagePath = "userImages/\(uid)\(Date().hashValue).jpg"
                
                StorageService.shared.saveImage(image: createUserRequest.userImage, imagePath: imagePath) { url, error in
                    if let error = error {
                        completion(false, error)
                        return
                    }
                    
                    user.userImageUrl = url?.absoluteString ?? ""
                    user.userImagePath = imagePath
                    
                    UserService.shared.saveUser(user: user, uid: user.uid) { error in
                        if let error = error {
                            completion(false, error)
                            return
                        }
                        
                        UserService.currentUser = user
                        completion(true, nil)
                        return
                    }
                }
            }
        }
    }
    
    // MARK: Sign in
    public func signIn(email: String, password: String, completion: @escaping (_ error: Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard self != nil else { return }
                    
            if let error = error {
                completion(error)
                return
            }
            
            guard let _ = authResult else {
                print(error!.localizedDescription)
                return
            }
            
            Task {
                await UserService.shared.getUser(uid: authResult!.user.uid) { user, error in
                    if let error = error {
                        completion(error)
                        return
                    }
                    
                    UserService.currentUser = user
                    completion(nil)
                }
            }
        }
    }
    
    // MARK: Sign out
    public func signOut(completion: @escaping (_ error: Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
            return
        } catch let error {
            completion(error)
            return
        }
    }
    
}
