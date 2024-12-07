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
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            setImage(selection: imageSelection)
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
    
    init(program: Program, programImage: UIImage?) {
        self.programId = program.id
        self.imagePath = program.imagePath
        self.title = program.title
        self.weeks = String(program.weeks)
        self.description = String(program.description ?? "")
        self.isPrivate = program.isPrivate
        self.free = program.free
        self.price = program.price == 0 ? "" : String(program.price)
        
        self.programImage = programImage
    }
    
    // MARK: Save program
    public func saveProgram() async {
        self.isLoading = true
        
        do {
            var newProgram: EditProgramRequest
            var newImageUrl: String?
            var newImagePath: String?
            
            // Check if new image was selected, check if imageSelection is nil
            if imageSelection != nil {
                guard let imageData = programImage!.pngData() else {
                    print("Couldn't get data from image.")
                    return
                }
                
                // Check if image needs to be replaced or added
                if self.imagePath != nil {
                    try await StorageService.shared.updateImage(imagePath: self.imagePath!, newImage: imageData)
                } else {
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
                    
                    newImageUrl = imageUrl
                    newImagePath = imagePath
                }
                
                newProgram = EditProgramRequest(
                    programId: self.programId,
                    title: self.title,
                    description: self.description,
                    imageUrl: newImageUrl,
                    imagePath: newImagePath,
                    price: Int(self.price),
                    weeks: Int(self.weeks)!,
                    free: self.free,
                    isPrivate: self.isPrivate
                )
            } else {
                newProgram = EditProgramRequest(
                    programId: self.programId,
                    title: self.title,
                    description: self.description,
                    price: Int(self.price),
                    weeks: Int(self.weeks)!,
                    free: self.free,
                    isPrivate: self.isPrivate
                )
            }
            
            // Update program
            try await ProgramService.shared.editProgram(editProgramRequest: newProgram)
            
            
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

