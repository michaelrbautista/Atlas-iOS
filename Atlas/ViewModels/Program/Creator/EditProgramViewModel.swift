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
    @Published var title: String = ""
    @Published var weeks: String = ""
    @Published var description: String = ""
    @Published var isPrivate: Bool = false
    @Published var free: Bool = false
    @Published var price: String = ""
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage = ""
    
    init(program: Program) {
        self.programId = program.id
        self.title = program.title
        self.weeks = String(program.weeks)
        self.description = String(program.description ?? "")
        self.isPrivate = program.isPrivate
        self.free = program.free
        self.price = program.price == 0 ? "" : String(program.price)
    }
    
    // MARK: Save program
    public func saveProgram() async {
        self.isLoading = true
        
        // Check if new image was selected
        
        // Update image
        
        // Update program
        
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

