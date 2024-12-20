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
        print("filePath: \(filePath)")
        do {
            let _ = try await SupabaseService.shared.supabase.storage
                .from(bucketName)
                .remove(paths: [filePath])
        } catch {
            print("Error deleting file")
            throw error
        }
    }
    
    // MARK: Save image
    public func saveImage(file: Data, bucketName: String, fileName: String, fileType: String) async throws -> String {
        do {
            try await SupabaseService.shared.supabase.storage
                .from(bucketName)
                .upload(
                    path: fileName,
                    file: file,
                    options: FileOptions(
                        cacheControl: "3600",
                        contentType: "image/\(fileType)",
                        upsert: false
                    )
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
    
    // MARK: Update image
    public func updateImage(file: Data, bucketName: String, fileName: String, fileType: String) async throws {
        do {
            try await SupabaseService.shared.supabase.storage
                .from(bucketName)
                .update(
                    path: fileName,
                    file: file,
                    options: FileOptions(
                        cacheControl: "3600",
                        contentType: "image/\(fileType)",
                        upsert: true
                    )
                )
        } catch {
            throw error
        }
    }
    
    // MARK: Save video
    public func saveVideo(file: Data, bucketName: String, fileName: String) async throws -> String {
        do {
            try await SupabaseService.shared.supabase.storage
                .from(bucketName)
                .upload(
                    path: fileName,
                    file: file,
                    options: FileOptions(
                        cacheControl: "3600",
                        contentType: "video/mp4",
                        upsert: false
                    )
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
    
    // MARK: Update video
    public func updateVideo(file: Data, bucketName: String, fileName: String) async throws {
        do {
            try await SupabaseService.shared.supabase.storage
                .from(bucketName)
                .update(
                    path: fileName,
                    file: file,
                    options: FileOptions(
                        cacheControl: "3600",
                        contentType: "video/mp4",
                        upsert: true
                    )
                )
        } catch {
            throw error
        }
    }
}

public extension Data {
    var imageExtension: String {
        var values = [UInt8](repeating:0, count:1)
        self.copyBytes(to: &values, count: 1)

        let ext: String
        switch (values[0]) {
        case 0xFF:
            ext = "jpeg"
        case 0x89:
            ext = "png"
        default:
            ext = "jpeg"
        }
        return ext
    }
}
