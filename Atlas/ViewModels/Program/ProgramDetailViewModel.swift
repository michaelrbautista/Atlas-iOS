//
//  ProgramDetailViewModel.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI

final class ProgramDetailViewModel: ObservableObject {
    
    // MARK: Variables
    var programId: String
    var program: Program? = nil
    var isCreator = false
    
    @Published var isLoading = true
    @Published var isSaving = false
    @Published var isDeleting = false
    
    @Published var isPurchased = false
    @Published var isStarted = false
    
    @Published var programImage: UIImage? = nil
    @Published var programImageIsLoading = true
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage = ""
    
    // MARK: Initializer
    init(programId: String) {
        self.programId = programId
    }
    
    #warning("Check if user is subscribed")
    
    // MARK: Get program
    @MainActor
    public func getProgram() async {
        Task {
            do {
                // Get program
                let program = try await ProgramService.shared.getProgram(programId: programId)
                
                self.program = program
                self.isCreator = program.createdBy?.id == UserService.currentUser?.id
                
                // Check if user has already purchased the program
                var checkIsPurchased = false
                if !self.isCreator {
                    checkIsPurchased = try await ProgramService.shared.checkIfUserPurchasedProgram(programId: program.id)
                    self.isPurchased = checkIsPurchased
                }
                
                // Check is user started the program
                if let startedProgramId = UserDefaults.standard.value(forKey: "startedProgram") as? String {
                    if startedProgramId == self.programId {
                        self.isStarted = true
                    }
                }
                
                self.isLoading = false
                
                // Get image
                if let imageUrl = program.imageUrl {
                    try await self.getProgramImage(imageUrl: imageUrl)
                } else {
                    self.programImageIsLoading = false
                    self.programImage = UIImage(systemName: "figure.run")
                }
            } catch {
                self.isLoading = false
                self.didReturnError = true
                self.returnedErrorMessage = error.localizedDescription
            }
        }
    }
    
    // MARK: Get program image
    @MainActor
    public func getProgramImage(imageUrl: String) async throws {
        self.programImageIsLoading = true
        
        guard let imageUrl = URL(string: imageUrl) else {
            self.programImageIsLoading = false
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: imageUrl)
            
            guard let image = UIImage(data: data) else {
                return
            }
            
            self.programImageIsLoading = false
            self.programImage = image
        } catch {
            throw error
        }
    }
    
    @MainActor
    public func unsaveProgram() async throws {
        do {
            try await ProgramService.shared.unsaveProgram(programId: program!.id)
            
            self.isPurchased = false
        } catch {
            self.didReturnError = true
            self.returnedErrorMessage = error.localizedDescription
        }
    }
    
    // MARK: Delete program
    @MainActor
    public func deleteProgram() async {
        self.isDeleting = true
        do {
            var deleteImagePath: String? = nil
            
            if self.program?.imagePath != nil {
                deleteImagePath = self.program!.imagePath
            }
            
            // Delete program from database
            try await ProgramService.shared.deleteProgram(programId: self.programId)
            
            // Delete image from storage
            if deleteImagePath != nil {
                try await StorageService.shared.deleteFile(bucketName: "program_images", filePath: deleteImagePath!)
            }
        } catch {
            self.isLoading = false
            self.didReturnError = true
            self.returnedErrorMessage = error.localizedDescription
        }
    }
    
    // MARK: Save program
    @MainActor
    public func saveProgram() async throws {
        self.isSaving = true
        
        guard let creatorId = self.program?.createdBy?.id else {
            self.isLoading = false
            self.didReturnError = true
            self.returnedErrorMessage = "Couldn't save program."
            return
        }
        
        let purchasedProgram = PurchaseProgramRequest(programId: self.programId, createdBy: creatorId)
        
        do {
            try await ProgramService.shared.saveProgram(purchaseProgramRequest: purchasedProgram)
            
            self.isPurchased = true
            self.isSaving = false
        } catch {
            self.isSaving = false
            self.didReturnError = true
            self.returnedErrorMessage = error.localizedDescription
        }
    }
}
