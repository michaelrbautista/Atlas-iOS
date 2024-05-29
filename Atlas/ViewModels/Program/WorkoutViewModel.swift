//
//  WorkoutViewModel.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI
import FirebaseFirestore

final class WorkoutViewModel: ObservableObject {
    
    // MARK: Variables
    @Published var isLoading = false
    @Published var endReached = false
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage: String? = nil
    
    @Published var programs = [SavedProgram]()
    
    var fetchIndex = 0
    var userId: String
    
    // MARK: Initializaer
    init() {
        isLoading = true
        
        guard let currentUserId = UserService.currentUser?.id.description else {
            userId = ""
            self.didReturnError = true
            self.returnedErrorMessage = "Couldn't get current user."
            return
        }
        
        self.userId = currentUserId
        
        Task {
            await getSavedPrograms()
        }
    }
    
    // MARK: Refresh
    public func pulledRefresh() async {
        DispatchQueue.main.async {
            self.programs = [SavedProgram]()
            self.endReached = false
        }
        
        fetchIndex = 0
        
        await getSavedPrograms()
    }
    
    // MARK: Get my saved programs
    @MainActor
    public func getSavedPrograms() async {
        self.isLoading = true
        
//        fetchIndex += 8
        
        do {
            let programs = try await WorkoutService.shared.getSavedPrograms(userId: userId, fetch_index: fetchIndex)
            
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
