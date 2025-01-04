//
//  EditLibraryExerciseViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 12/19/24.
//

import SwiftUI
import PhotosUI

final class EditLibraryExerciseViewModel: ObservableObject {
    @Published var isSaving = false
    
    @Published var exerciseVideo: Data? = nil
    @Published var videoSelection: PhotosPickerItem? = nil {
        didSet {
            setVideo(selection: videoSelection)
        }
    }
    @Published var videoUrl: URL?
    
    @Published var exerciseId: String
    @Published var videoPath: String?
    @Published var title = ""
    @Published var instructions = ""
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage = ""
    
    // MARK: Initializer
    init(exercise: FetchedExercise, exerciseVideo: Data?) {
        self.exerciseId = exercise.id
        self.videoPath = exercise.videoPath
        self.title = exercise.title
        self.instructions = exercise.instructions ?? ""
        
        self.exerciseVideo = exerciseVideo
    }
    
    // MARK: Save exercise
    @MainActor
    public func saveExercise() async -> FetchedExercise? {
        self.isSaving = true
        
        // Check fields
        if title == "" {
            didReturnError = true
            returnedErrorMessage = "Please fill in all fields"
            return nil
        }
        
        do {
            var newExercise: EditLibraryExerciseRequest
            var newVideoUrl: String?
            var newVideoPath: String?
            
            // Check if new image was selected
            if videoSelection != nil {
                guard let exerciseVideoData = self.exerciseVideo else {
                    print("Couldn't get data from video.")
                    return nil
                }
                
                // Check if image needs to be replaced or added
                if self.videoPath != nil {
                    try await StorageService.shared.updateVideo(file: exerciseVideoData, bucketName: "exercise_videos", fileName: self.videoPath!)
                } else {
                    guard let currentUser = UserService.currentUser else {
                        print("Couldn't get current user.")
                        return nil
                    }
                    
                    let videoPath = "\(currentUser.id.description)/\(Date().hashValue).jpg"
                    
                    guard let exerciseVideoData = self.exerciseVideo else {
                        print("Couldn't get data from video.")
                        return nil
                    }
                    
                    let videoUrl = try await StorageService.shared.saveVideo(file: exerciseVideoData, bucketName: "exercise_videos", fileName: videoPath)
                    
                    newVideoUrl = videoUrl
                    newVideoPath = videoPath
                }
                
                newExercise = EditLibraryExerciseRequest(
                    id: self.exerciseId,
                    title: self.title,
                    instructions: self.instructions == "" ? nil : self.instructions,
                    videoUrl: newVideoUrl,
                    videoPath: newVideoPath
                )
            } else {
                newExercise = EditLibraryExerciseRequest(
                    id: self.exerciseId,
                    title: self.title,
                    instructions: self.instructions == "" ? nil : self.instructions
                )
            }
            
            // Update exercise
            let editedExercise = try await ExerciseService.shared.editLibraryExercise(editExerciseRequest: newExercise)
            
            // Update program on UI
            return editedExercise
        } catch {
            self.isSaving = false
            self.didReturnError = true
            self.returnedErrorMessage = error.localizedDescription
            return nil
        }
    }
    
    // MARK: Set video
    private func setVideo(selection: PhotosPickerItem?) {
        guard let video = videoSelection else {
            return
        }
        
        Task {
            if let data = try? await video.loadTransferable(type: Data.self) {
                DispatchQueue.main.async {
                    self.exerciseVideo = data
                }
            }
            
            video.loadTransferable(type: Movie.self) { result in
                switch result {
                case .success(let movie):
                    if let movie = movie {
                        DispatchQueue.main.async {
                            self.videoUrl = movie.url
                        }
                    } else {
                        print("movie is nil")
                    }
                case .failure(let failure):
                    fatalError("\(failure)")
                }
            }
        }
    }
    
    struct Movie: Transferable {
        let url: URL
        
        static var transferRepresentation: some TransferRepresentation {
            FileRepresentation(contentType: .movie) { movie in
                SentTransferredFile(movie.url)
            } importing: { receivedData in
                let fileName = receivedData.file.lastPathComponent
                let copy: URL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
                
                if FileManager.default.fileExists(atPath: copy.path) {
                    try FileManager.default.removeItem(at: copy)
                }
                
                try FileManager.default.copyItem(at: receivedData.file, to: copy)
                return .init(url: copy)
            }
        }
    }
    
}
