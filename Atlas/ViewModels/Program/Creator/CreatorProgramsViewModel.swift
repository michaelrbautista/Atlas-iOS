//
//  CreatorProgramsViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 12/5/24.
//

import SwiftUI

final class CreatorProgramsViewModel: ObservableObject {
    @Published var isLoading = true
    
    @Published var offset = 0
    @Published var endReached = false
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage = ""
    
    @Published var programs = [Program]()
    
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
    }
    
    // MARK: Refresh
    @MainActor
    public func pulledRefresh() async {
        self.programs = [Program]()
        
        await getCreatorsPrograms()
    }
    
    // MARK: Remove program
    @MainActor
    public func removeProgram(index: Int) {
        self.programs.remove(at: index)
    }
    
    // MARK: Get creator's programs
    @MainActor
    public func getCreatorsPrograms() async {
        do {
            let programs = try await ProgramService.shared.getCreatorsPrograms(userId: self.userId, offset: self.offset)
            
            self.programs.append(contentsOf: programs)
            
            if programs.count < 10 {
                self.endReached = true
            } else {
                self.endReached = false
                offset += 10
            }
            
            self.isLoading = false
        } catch {
            self.isLoading = false
            self.didReturnError = true
            self.returnedErrorMessage = error.localizedDescription
        }
    }
}
