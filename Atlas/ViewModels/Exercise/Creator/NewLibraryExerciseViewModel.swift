//
//  NewLibraryExerciseViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 12/14/24.
//

import SwiftUI
import PhotosUI

final class NewLibraryExerciseViewModel: ObservableObject {
    @Published var isLoading = false
    
    @Published var exerciseVideo: Data? = nil
    @Published var videoSelection: PhotosPickerItem? = nil {
        didSet {
            setVideo(selection: videoSelection)
        }
    }
    @Published var videoUrl: URL?
    
    @Published var name = ""
    @Published var instructions = ""
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage = ""
    
    @MainActor
    public func saveExercise() async -> FetchedExercise? {
        self.isLoading = true
        
        // Check fields
        if name == "" {
            didReturnError = true
            returnedErrorMessage = "Please fill in all fields"
            return nil
        }
        
        // Create exercise request
        var createExerciseRequest = CreateExerciseRequest(title: self.name, instructions: self.instructions == "" ? nil : self.instructions)
        
        do {
            // Save image to storage
            if exerciseVideo != nil {
                guard let currentUser = UserService.currentUser else {
                    print("Couldn't get current user.")
                    return nil
                }
                
                let videoPath = "\(currentUser.id.description)/\(Date().hashValue).mp4"
                
                let videoUrl = try await StorageService.shared.saveVideo(file: exerciseVideo!, bucketName: "exercise_videos", fileName: videoPath)
                
                createExerciseRequest.videoUrl = videoUrl
                createExerciseRequest.videoPath = videoPath
            }
            
            // Save program
            let newExercise = try await ExerciseService.shared.createLibraryExercise(createExerciseRequest: createExerciseRequest)
            
            return newExercise
        } catch {
            print(error)
            self.isLoading = false
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
