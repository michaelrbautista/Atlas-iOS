//
//  UserProgramsViewModel.swift
//  stayhard
//
//  Created by Michael Bautista on 3/26/24.
//

import SwiftUI

final class UserProgramsViewModel: ObservableObject {
    
    // MARK: Variables
    @Published var isLoading = false
    @Published var endReached = false
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage: String? = nil
    
    @Published var programs = [SavedProgram]()
    
    var userId: String
    
    init(userId: String) {
        self.userId = userId
    }
    
    @MainActor
    public func pulledRefresh() async {
        self.programs = [SavedProgram]()
        self.endReached = false
        
        await getCreatorPrograms()
    }
    
    @MainActor
    public func getCreatorPrograms() async {
        self.isLoading = true
        
        do {
            let programs = try await ProgramService.shared.getCreatorPrograms(creatorId: userId)
            
            self.isLoading = false
            
            self.programs = programs
            
            if programs.count > 8 {
                self.endReached = true
            }
        } catch {
            self.isLoading = false
            self.didReturnError = true
            self.returnedErrorMessage = error.localizedDescription
        }
    }
    
    public func updateProgram(newProgram: SavedProgram, programIndex: Int) {
        DispatchQueue.main.async {
            self.programs[programIndex] = newProgram
        }
    }
    
    public func insertProgramToBeginning(newProgram: SavedProgram) {
        DispatchQueue.main.async {
            self.programs.insert(newProgram, at: 0)
        }
    }
    
    public func addPrograms(newPrograms: [SavedProgram]) {
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
