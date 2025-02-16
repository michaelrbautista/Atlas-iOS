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
    
    @Published var isSubscribed = false
    @Published var isPurchased = false
    @Published var isStarted = false
    
    @Published var programImage: UIImage? = nil
    @Published var programImageIsLoading = true
    
    @Published var didReturnError = false
    @Published var errorMessage = ""
    
    // MARK: Initializer
    init(programId: String) {
        self.programId = programId
    }
    
    // MARK: Get program
    @MainActor
    public func getProgram() async {
        Task {
            do {
                // Get program
                let program = try await ProgramService.shared.getProgram(programId: programId)
                
                self.program = program
                
                guard let currentUserId = UserService.currentUser?.id, let creatorId = program.createdBy?.id else {
                    self.isLoading = false
                    self.didReturnError = true
                    self.errorMessage = "There was an error getting the current user and creator id."
                    return
                }
                self.isCreator = creatorId == currentUserId
                
                if !self.isCreator {
                    // Check if subscribed
                    let checkIsSubscribed = try await SubscriptionService.shared.checkSubscription(userId: currentUserId, creatorId: creatorId)
                    self.isSubscribed = checkIsSubscribed
                    
                    // Check if user has already purchased the program
                    let checkIsPurchased = try await ProgramService.shared.checkIfUserPurchasedProgram(programId: program.id)
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
                self.errorMessage = error.localizedDescription
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
    
    // MARK: Finish program
    @MainActor
    public func finishProgram() {
        UserDefaults.standard.removeObject(forKey: "startedProgram")
        UserDefaults.standard.removeObject(forKey: "startDayAsNumber")
        UserDefaults.standard.removeObject(forKey: "startDate")
        self.isStarted = false
    }
    
    // MARK: Save program
    @MainActor
    public func saveProgram() async throws {
        self.isSaving = true
        
        guard let creatorId = self.program?.createdBy?.id else {
            self.isLoading = false
            self.didReturnError = true
            self.errorMessage = "Couldn't save program."
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
            self.errorMessage = error.localizedDescription
        }
    }
    
    // MARK: Unsave program
    @MainActor
    public func unsaveProgram() async throws {
        self.isSaving = true
        
        do {
            try await ProgramService.shared.unsaveProgram(programId: program!.id)
            
            if isStarted {
                finishProgram()
            }
            
            self.isPurchased = false
            self.isSaving = false
        } catch {
            self.isSaving = false
            self.didReturnError = true
            self.errorMessage = error.localizedDescription
        }
    }
}
