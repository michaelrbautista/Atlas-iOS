//
//  NewProgramViewModel.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI
import PhotosUI

final class NewProgramViewModel: ObservableObject {
    
    // MARK: Program image
    @Published var programImage: UIImage? = nil
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            setImage(selection: imageSelection)
        }
    }
    
    // MARK: Program data
    @Published var title: String = ""
    @Published var description: String = ""
    
    @Published var isSaving = false
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage: String? = nil
    
    // MARK: Image
    private func setImage(selection: PhotosPickerItem?) {
        guard let selection else {
            return
        }
        
        Task {
            if let data = try? await selection.loadTransferable(type: Data.self) {
                if let uiImage = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.programImage = uiImage
                    }
                }
            }
        }
    }
    
    // MARK: Create new program
    @MainActor
    public func createNewProgram() async -> SavedProgram? {
        if title == "" {
            self.didReturnError = true
            self.returnedErrorMessage = "Please enter a title."
            return nil
        }
        
        isSaving = true
        
        guard let currentUserId = UserService.currentUser?.id.description else {
            self.didReturnError = true
            self.returnedErrorMessage = "Couldn't create program."
            return nil
        }
        
        var program = Program(
            title: title,
            description: description,
            createdBy: currentUserId
        )
        
        do {
            // Save image
            if programImage != nil {
                let imagePath = "\(currentUserId)\(Date().hashValue).jpg"
                
                guard let imageData = programImage!.pngData() else {
                    print("Couldn't get data from image.")
                    return nil
                }
                
                let imageUrl = try await StorageService.shared.saveImage(image: imageData, bucketName: "program_images", fileName: imagePath)
                
                program.imageUrl = imageUrl
                program.imagePath = imagePath
            }
            
            let savedProgram = try await WorkoutService.shared.createProgram(program: program)
            
            isSaving = false
            
            return savedProgram
        } catch {
            isSaving = false
            self.didReturnError = true
            self.returnedErrorMessage = error.localizedDescription
            print(error)
            return nil
        }
    }
}
