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
