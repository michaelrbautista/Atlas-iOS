//
//  LibraryExerciseDetailViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 5/21/24.
//

import SwiftUI
import AVKit

final class LibraryExerciseDetailViewModel: ObservableObject {
    
    // MARK: Variables
    @Published var exercise: FetchedExercise
    
    @Published var player: AVPlayer? = nil
    
    @Published var isLoading: Bool = false
    @Published var isDeleting = false
    
    @Published var exerciseVideo: Data? = nil
    @Published var exerciseVideoIsLoading = false
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage = ""
    
    // MARK: Initializer
    init(exercise: FetchedExercise) {
        self.exercise = exercise
        
        // Get video
        if let videoUrl = exercise.videoUrl {
            self.exerciseVideoIsLoading = true
            
            Task {
                try await self.getExerciseVideo(videoUrl: videoUrl)
                
                DispatchQueue.main.async {
                    self.exerciseVideoIsLoading = false
                }
            }
        }
    }
    
    // MARK: Get exercise video
    @MainActor
    public func getExerciseVideo(videoUrl: String) async throws {
        self.exerciseVideoIsLoading = true
        
        guard let videoUrl = URL(string: videoUrl) else {
            self.exerciseVideoIsLoading = false
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: videoUrl)
            
            self.exerciseVideo = data
            self.exerciseVideoIsLoading = false
        } catch {
            throw error
        }
    }
    
    // MARK: Delete exercise
    @MainActor
    public func deleteExercise() async {
        self.isDeleting = true
        do {
            var deleteVideoPath: String? = nil
            
            if self.exercise.videoPath != nil {
                deleteVideoPath = self.exercise.videoPath
            }
            
            try await ExerciseService.shared.deleteLibraryExercise(exerciseId: self.exercise.id)
            
            // Delete image from storage
            if let deletePath = deleteVideoPath {
                try await StorageService.shared.deleteFile(bucketName: "exercise_videos", filePath: deletePath)
            }
        } catch {
            self.isLoading = false
            self.didReturnError = true
            self.returnedErrorMessage = error.localizedDescription
        }
    }
}
