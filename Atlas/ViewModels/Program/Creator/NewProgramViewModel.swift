//
//  NewProgramViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 12/5/24.
//

import SwiftUI
import PhotosUI

final class NewProgramViewModel: ObservableObject {
    @Published var isLoading = false
    
    @Published var programImage: UIImage? = nil
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            setImage(selection: imageSelection)
        }
    }
    
    @Published var title: String = ""
    @Published var weeks: String = ""
    @Published var description: String = ""
    @Published var isPrivate: Bool = false
    @Published var free: Bool = false
    @Published var price: String = ""
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage = ""
    
    @MainActor
    public func saveProgram() async {
        self.isLoading = true
        
        // Check fields
        if title == "" || weeks == "" || Int(weeks)! < 1 || (!free && price == "") {
            didReturnError = true
            returnedErrorMessage = "Please fill in all fields"
            return
        }
        
        // Create program form
        var createProgramRequest = CreateProgramRequest(
            title: title,
            description: description != "" ? description : nil,
            price: !free ? Int(price) : nil,
            weeks: Int(weeks) ?? 1,
            free: free,
            isPrivate: isPrivate
        )
        
        do {
            // Save image to storage
            if programImage != nil {
                guard let currentUser = UserService.currentUser else {
                    print("Couldn't get current user.")
                    return
                }
                
                let imagePath = "\(currentUser.id.description)\(Date().hashValue).jpg"
                
                guard let imageData = programImage!.pngData() else {
                    print("Couldn't get data from image.")
                    return
                }
                
                let imageUrl = try await StorageService.shared.saveFile(file: imageData, bucketName: "program_images", fileName: imagePath)
                
                createProgramRequest.imageUrl = imageUrl
                createProgramRequest.imagePath = imagePath
            }
            
            // Save program
            try await ProgramService.shared.createProgram(createProgramRequest: createProgramRequest)
        } catch {
            self.isLoading = false
            self.didReturnError = true
            self.returnedErrorMessage = error.localizedDescription
        }
    }
    
    // MARK: Set image
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
}

