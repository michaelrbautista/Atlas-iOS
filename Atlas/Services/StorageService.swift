//
//  StorageService.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI
import Supabase

final class StorageService {
    
    public static let shared = StorageService()
    
    // MARK: Delete file
    public func deleteFile(bucketName: String, filePath: String) async throws {
        do {
            let _ = try await SupabaseService.shared.supabase.storage
                .from(bucketName)
                .remove(paths: [filePath])
        } catch {
            print("Error deleting file")
            throw error
        }
    }
    
    // MARK: Save file
    public func saveFile(file: Data, bucketName: String, fileName: String) async throws -> String {
        do {
            try await SupabaseService.shared.supabase.storage
                .from(bucketName)
                .upload(
                    path: "\(fileName)",
                    file: file
                )
            
            let imageUrl = try SupabaseService.shared.supabase.storage
              .from(bucketName)
              .getPublicURL(path: fileName)
            
            return imageUrl.absoluteString
        } catch {
            print("Error saving file")
            throw error
        }
    }
    
    // MARK: Update file
    public func udpateImage(imagePath: String, newImage: Data) async throws {
        do {
            try await SupabaseService.shared.supabase.storage
                .from("program_images")
                .update(
                    path: imagePath,
                    file: newImage
                )
        } catch {
            throw error
        }
    }
}
