//
//  NewExerciseViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 5/21/24.
//

import SwiftUI
import PhotosUI
import AVKit

final class NewExerciseViewModel: ObservableObject {
    // MARK: Exercise video
    @Published var exerciseVideo: Data? = nil
    @Published var videoSelection: PhotosPickerItem? = nil {
        didSet {
            setVideo(selection: videoSelection)
        }
    }
    
    @Published var player: AVPlayer? = nil
    
    // MARK: Workout data
    var workoutId: String
    var exerciseNumber: Int
    
    @Published var name: String = ""
    @Published var sets: String = ""
    @Published var reps: String = ""
    @Published var instructions: String = ""
    
    @Published var isSaving = false
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage: String? = nil
    
    init(workoutId: String, exerciseNumber: Int) {
        self.workoutId = workoutId
        self.exerciseNumber = exerciseNumber
    }
    
    // MARK: Create new workout
    @MainActor
    public func createNewExercise() async -> Exercise? {
        isSaving = true
        
        guard let currentUserId = UserService.currentUser?.id.description else {
            self.didReturnError = true
            self.returnedErrorMessage = "Couldn't create program."
            return nil
        }
        
        var newExercise = Exercise(
            createdBy: currentUserId,
            workoutId: workoutId,
            exerciseNumber: exerciseNumber,
            name: name,
            sets: sets,
            reps: reps,
            instructions: instructions
        )
        
        do {
            // Save video
            if exerciseVideo != nil {
                let videoPath = "\(currentUserId)\(Date().hashValue).mp4"
                
                let videoUrl = try await StorageService.shared.saveFile(file: exerciseVideo!, bucketName: "exercise_videos", fileName: videoPath)
                
                newExercise.videoUrl = videoUrl
                newExercise.videoPath = videoPath
            }
            
            let createdExercise = try await ExerciseService.shared.createExercise(exercise: newExercise)
            
            isSaving = false
            
            return createdExercise
        } catch {
            isSaving = false
            self.didReturnError = true
            self.returnedErrorMessage = error.localizedDescription
            return nil
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
                            self.player = AVPlayer(url: movie.url)
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
}
