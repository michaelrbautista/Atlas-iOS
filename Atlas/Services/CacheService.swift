//
//  CacheService.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI

final class CacheService {
    
    public static let shared = WorkoutService()
    
    var imageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.totalCostLimit = 1024 * 1024 * 100
        return cache
    }()
    
    func addImage(imageUrl: String, imageToSave: UIImage) {
        imageCache.setObject(imageToSave, forKey: imageUrl as NSString)
    }
    
    func getImage(imageUrl: String) -> UIImage? {
        return imageCache.object(forKey: imageUrl as NSString)
    }
    
}
