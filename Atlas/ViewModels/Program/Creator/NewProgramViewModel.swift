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
    @Published var imageExtension: String = "jpeg"
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            Task {
                await setImage(selection: imageSelection)
            }
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
    public func saveProgram() async -> Program? {
        self.isLoading = true
        
        // Check fields
        if title == "" || weeks == "" || Int(weeks)! < 1 || (!free && price == "") {
            didReturnError = true
            returnedErrorMessage = "Please fill in all fields"
            return nil
        }
        
        // Create program form
        var createProgramRequest = CreateProgramRequest(
            title: title,
            description: description != "" ? description : nil,
            price: !free ? Double(price) : nil,
            weeks: Int(weeks) ?? 1,
            free: free,
            isPrivate: isPrivate
        )
        
        do {
            // Save image to storage
            if programImage != nil {
                guard let currentUser = UserService.currentUser else {
                    print("Couldn't get current user.")
                    return nil
                }
                
                let imagePath = "\(currentUser.id.description)/\(Date().hashValue).\(self.imageExtension)"
                
                guard let imageData = programImage!.jpegData(compressionQuality: 1) else {
                    print("Couldn't get data from image.")
                    return nil
                }
                
                let imageUrl = try await StorageService.shared.saveImage(file: imageData, bucketName: "program_images", fileName: imagePath, fileType: self.imageExtension)
                
                createProgramRequest.imageUrl = imageUrl
                createProgramRequest.imagePath = imagePath
            }
            
            // Save program
            let newProgram = try await ProgramService.shared.createProgram(createProgramRequest: createProgramRequest)
            
            return newProgram
        } catch {
            print(error)
            self.isLoading = false
            self.didReturnError = true
            self.returnedErrorMessage = error.localizedDescription
            return nil
        }
    }
    
    // MARK: Set image
    @MainActor
    private func setImage(selection: PhotosPickerItem?) {
        guard let selection else {
            return
        }
        
        Task {
            if let data = try? await selection.loadTransferable(type: Data.self) {
                self.imageExtension = data.imageExtension
                if let uiImage = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.programImage = uiImage
                    }
                }
            }
        }
    }
}

