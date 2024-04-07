//
//  UserService.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class UserService {
    
    public static let shared = UserService()
    public static let db = Firestore.firestore()
    static var currentUser: User? = nil
    
    // MARK: Update user
    public func updateUser(user: User, updateUserRequest: UpdateUserRequest, completion: @escaping (_ user: User?, _ error: Error?) -> Void) {
        var newUser = user
        
        // 1. Save image
        StorageService.shared.saveImage(image: updateUserRequest.userImage, imagePath: user.userImagePath) { url, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            // 2. Update and save user
            newUser.userImageUrl = url?.absoluteString ?? ""
            newUser.fullName = updateUserRequest.fullName
            newUser.username = updateUserRequest.username
            
            UserService.shared.saveUser(user: newUser, uid: newUser.uid) { error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                completion(newUser, nil)
                return
            }
        }
    }
    
    // MARK: Save user
    public func saveUser(user: User, uid: String, completion: @escaping (_ error: Error?) -> Void) {
        let userRef = UserService.db.collection("users").document(uid)
        
        do {
            try userRef.setData(from: user)
            completion(nil)
        } catch let error {
            completion(error)
        }
    }
    
    // MARK: Get user
    public func getUser(uid: String, completion: @escaping (_ user: User?, _ error: Error?) -> ()) async {
        let userRef = UserService.db.collection("users").document(uid)
        
        do {
            let user = try await userRef.getDocument(as: User.self)
            completion(user, nil)
        } catch {
            completion(nil, error)
        }
    }
    
    // MARK: Check if username exists
    public func checkUsername(username: String, completion: @escaping (_ available: Bool?, _ error: Error?) -> Void) async {
        do {
            let querySnapshot = try await UserService.db.collection("users").whereField("username", isEqualTo: username).getDocuments()
            
            if querySnapshot.count > 0 {
                completion(false, nil)
                return
            } else {
                completion(true, nil)
                return
            }
        } catch {
            completion(false, error)
            return
        }
    }
    
}
