//
//  AddVideoViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 4/14/24.
//

import SwiftUI
import PhotosUI
import AVKit

class AddVideoViewModel: ObservableObject {
    // MARK: Exercise video
    @Published var exerciseVideo: Data? = nil
    @Published var videoSelection: PhotosPickerItem? = nil {
        didSet {
            setVideo(selection: videoSelection)
        }
    }
    
    @Published var player: AVPlayer? = nil
    
    @Published var isSaving = false
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage: String? = nil
    
    public func saveVideo(program: Program, workoutId: Int, exerciseId: Int, completion: @escaping (_ url: URL) -> Void) {
        // Get current user
        guard let currentUser = UserService.currentUser else {
            print("Couldn't get current user.")
            return
        }
        
        isSaving = true
        
        let videoPath = "exerciseVideos/\(currentUser.id)\(Date().hashValue).mp4"
        
        guard let video = exerciseVideo else {
            print("No video was selected.")
            return
        }
        
        StorageService.shared.saveVideo(video: video, videoPath: videoPath) { url, error in
            if let error = error {
                self.didReturnError = true
                self.returnedErrorMessage = error.localizedDescription
                return
            }
            
            guard let videoUrl = url else {
                return
            }
            
            WorkoutService.shared.addVideoToExercise(program: program, videoUrl: videoUrl, videoPath: videoPath, workoutId: workoutId, exerciseId: exerciseId) { error in
                if let error = error {
                    self.didReturnError = true
                    self.returnedErrorMessage = error.localizedDescription
                    return
                }
                
                completion(videoUrl)
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
