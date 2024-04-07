//
//  StorageService.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI
import FirebaseStorage

final class StorageService {
    
    public static let shared = StorageService()
    public static let storage = Storage.storage().reference()
    
    // MARK: Save exercise videos
    public func saveExerciseVideos(exerciseVideos: [ExerciseVideo], completion: @escaping ([String]) -> Void) {
        
    }
    
    // MARK: Save image
    public func saveImage(image: UIImage?, imagePath: String, completion: @escaping (_ url: URL?, _ error: Error?) -> Void) {
        guard let image = image else {
            completion(nil, nil)
            return
        }
        
        let imageRef = StorageService.storage.child(imagePath)
        
        guard let imageData = image.pngData() else {
            completion(nil, nil)
            print("Couldn't get data from image.")
            return
        }
        
        imageRef.putData(imageData) { result in
            switch result {
            case .success(_):
                imageRef.downloadURL { url, error in
                    guard let downloadURL = url else {
                        print("Error downloading image URL.")
                        return
                    }
                    
                    if let error = error {
                        completion(nil, error)
                        return
                    }
                    
                    completion(downloadURL, nil)
                    return
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    // MARK: Delete image
    public func deleteImage(imagePath: String, completion: @escaping (_ error: Error?) -> Void) {
        let imageRef = StorageService.storage.child(imagePath)
        
        imageRef.delete { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
}
