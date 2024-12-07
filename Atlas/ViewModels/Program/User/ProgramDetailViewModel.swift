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
    
    @Published var isLoading = true
    @Published var isSaving = false
    
    @Published var isPurchased = false
    @Published var isStarted = false
    
    @Published var programImage: UIImage? = nil
    @Published var programImageIsLoading = true
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage = ""
    
    // MARK: Initializer
    init(programId: String) {
        self.programId = programId
        
        Task {
            await getProgram()
        }
    }
    
    // MARK: Get program
    @MainActor
    public func getProgram() async {
        Task {
            do {
                // Get program
                let program = try await ProgramService.shared.getProgram(programId: programId)
                
                // Check if user has already purchased the program
                let isPurchased = try await ProgramService.shared.checkIfUserPurchasedProgram(programId: program.id)
                
                // Check is user started the program
                if let startedProgramId = UserDefaults.standard.value(forKey: "startedProgram") as? String {
                    if startedProgramId == self.programId {
                        self.isStarted = true
                    }
                }
                
                self.program = program
                self.isPurchased = isPurchased
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
            try await ProgramService.shared.unsaveProgram(program: program!)
            
            self.isPurchased = false
        } catch {
            self.didReturnError = true
            self.returnedErrorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    public func saveProgram() async throws {
//        self.isSaving = true
//        
//        guard let currentUserId = UserService.currentUser?.id else {
//            self.isLoading = false
//            self.didReturnError = true
//            self.returnedErrorMessage = "Couldn't get current user."
//            return
//        }
//        
//        let purchasedProgram = PurchasedProgram(
//            programId: self.programId,
//            purchasedBy: currentUserId,
//            createdBy: self.team!.createdBy
//        )
//        
//        do {
//            try await ProgramService.shared.saveProgram(purchasedProgram: purchasedProgram)
//            
//            self.isPurchased = true
//            self.isSaving = false
//        } catch {
//            self.isSaving = false
//            self.didReturnError = true
//            self.returnedErrorMessage = error.localizedDescription
//        }
    }
}
