//
//  CreatorProgramsViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 12/5/24.
//

import SwiftUI

final class CreatorProgramsViewModel: ObservableObject {
    // MARK: Variables
    @Published var isLoading = true
    
    @Published var offset = 0
    @Published var endReached = false
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage = ""
    
    @Published var programs = [FetchedProgram]()
    
    var userId: String
    
    // MARK: Initializaer
    init() {
        guard let currentUserId = UserService.currentUser?.id.description else {
            userId = ""
            self.didReturnError = true
            self.returnedErrorMessage = "Couldn't get current user."
            return
        }
        
        self.userId = currentUserId
        
        Task {
            await getCreatorsPrograms()
        }
    }
    
    // MARK: Refresh
    @MainActor
    public func pulledRefresh() async {
        self.programs = [FetchedProgram]()
//        self.endReached = false
//
        await getCreatorsPrograms()
    }
    
    // MARK: Get my saved programs
    @MainActor
    public func getCreatorsPrograms() async {
        do {
            let programs = try await ProgramService.shared.getCreatorsPrograms(userId: self.userId)
            
            self.programs.append(contentsOf: programs)
            
            if programs.count < 10 {
                self.endReached = true
            } else {
                offset += 10
            }
            
            self.isLoading = false
        } catch {
            self.isLoading = false
            self.didReturnError = true
            self.returnedErrorMessage = error.localizedDescription
        }
    }
    
    public func addPrograms(newPrograms: [FetchedProgram]) {
        DispatchQueue.main.async {
            self.programs.append(contentsOf: newPrograms)
        }
    }
    
    public func removeProgram(programIndex: Int) {
        DispatchQueue.main.async {
            self.programs.remove(at: programIndex)
        }
    }
}
