//
//  EditProgramViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 12/6/24.
//

import SwiftUI
import PhotosUI

final class EditProgramViewModel: ObservableObject {
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
    
    @Published var programId: String
    @Published var imagePath: String?
    @Published var title: String = ""
    @Published var weeks: String = ""
    @Published var description: String = ""
    @Published var isPrivate: Bool = false
    @Published var free: Bool = false
    @Published var price: String = ""
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage = ""
    
    init(program: EditProgramRequest, programImage: UIImage?) {
        self.programId = program.id
        self.imagePath = program.imagePath
        self.title = program.title
        self.weeks = String(program.weeks)
        self.description = program.description ?? ""
        self.isPrivate = program.isPrivate
        self.free = program.free
        self.price = String(format: "%.2f", program.price ?? 1.00)
        
        self.programImage = programImage
    }
    
    // MARK: Save program
    @MainActor
    public func saveProgram() async -> Program? {
        self.isLoading = true
        
        // Check fields
        if self.title == "" {
            didReturnError = true
            returnedErrorMessage = "Please fill in all fields"
            return nil
        }
        
        do {
            var newProgram: EditProgramRequest
            var newImageUrl: String?
            var newImagePath: String?
            
            // Check if new image was selected, check if imageSelection is nil
            if imageSelection != nil {
                guard let imageData = programImage!.pngData() else {
                    print("Couldn't get data from image.")
                    return nil
                }
                
                // Check if image needs to be replaced or added
                if self.imagePath != nil {
                    try await StorageService.shared.updateImage(file: imageData, bucketName: "program_images", fileName: self.imagePath!, fileType: self.imageExtension)
                } else {
                    guard let currentUser = UserService.currentUser else {
                        print("Couldn't get current user.")
                        return nil
                    }
                    
                    let imagePath = "\(currentUser.id.description)/\(Date().hashValue).jpg"
                    
                    guard let imageData = programImage!.jpegData(compressionQuality: 1) else {
                        print("Couldn't get data from image.")
                        return nil
                    }
                    
                    let imageUrl = try await StorageService.shared.saveImage(file: imageData, bucketName: "program_images", fileName: imagePath, fileType: self.imageExtension)
                    
                    newImageUrl = imageUrl
                    newImagePath = imagePath
                }
                
                newProgram = EditProgramRequest(
                    id: self.programId,
                    title: self.title,
                    description: self.description == "" ? nil : self.description,
                    imageUrl: newImageUrl,
                    imagePath: newImagePath,
                    price: Double(self.price),
                    weeks: Int(self.weeks) ?? 1,
                    free: self.free,
                    isPrivate: self.isPrivate
                )
            } else {
                newProgram = EditProgramRequest(
                    id: self.programId,
                    title: self.title,
                    description: self.description == "" ? nil : self.description,
                    price: Double(self.price),
                    weeks: Int(self.weeks) ?? 1,
                    free: self.free,
                    isPrivate: self.isPrivate
                )
            }
            
            // Update program
            let editedProgram = try await ProgramService.shared.editProgram(programId: self.programId, editProgramRequest: newProgram)
            
            return editedProgram
            
            // Update program on UI
            
        } catch {
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

