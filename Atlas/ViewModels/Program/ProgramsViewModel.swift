//
//  WorkoutViewModel.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI

final class ProgramsViewModel: ObservableObject {
    
    // MARK: Variables
    @Published var isLoading = false
    @Published var endReached = false
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage: String? = nil
    
    @Published var programs = [SavedProgram]()
    
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
        self.programs = [SavedProgram]()
        self.endReached = false
        
        await getSavedPrograms()
    }
    
    // MARK: Get my saved programs
    @MainActor
    public func getSavedPrograms() async {
        self.isLoading = true
        
        do {
            let programs = try await ProgramService.shared.getSavedPrograms(userId: userId)
            
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
