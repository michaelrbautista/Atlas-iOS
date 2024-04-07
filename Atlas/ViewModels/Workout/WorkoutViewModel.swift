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
    var lastProgramFetchedRef: QueryDocumentSnapshot? = nil
    @Published var isLoading = false
    @Published var endReached = false
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage: String? = nil
    
    @Published var programs = [SavedProgram]()
    
    // MARK: Initializaer
    init() {
        isLoading = true
        
        guard let currentUserUid = UserService.currentUser?.uid else {
            didReturnError = true
            returnedErrorMessage = "Error getting workouts."
            return
        }
        
        let getMySavedProgramsRequest = GetProgramsRequest(
            uid: currentUserUid,
            lastProgramRef: self.lastProgramFetchedRef
        )
        
        Task {
            await getMySavedPrograms(getMySavedProgramsRequest: getMySavedProgramsRequest)
        }
    }
    
    // MARK: Refresh
    public func pulledRefresh() async {
        DispatchQueue.main.async {
            self.programs = [SavedProgram]()
        }
        
        guard let currentUserUid = UserService.currentUser?.uid else {
            didReturnError = true
            returnedErrorMessage = "Error getting workouts."
            return
        }
        
        self.lastProgramFetchedRef = nil
        
        let getMySavedProgramsRequest = GetProgramsRequest(
            uid: currentUserUid,
            lastProgramRef: self.lastProgramFetchedRef
        )
        
        await getMySavedPrograms(getMySavedProgramsRequest: getMySavedProgramsRequest)
    }
    
    // MARK: Get my saved programs
    public func getMySavedPrograms(getMySavedProgramsRequest: GetProgramsRequest) async {
        await WorkoutService.shared.getSavedPrograms(getProgramsRequest: getMySavedProgramsRequest) { newProgramRefs, lastProgramRef, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.didReturnError = true
                    self.returnedErrorMessage = error.localizedDescription
                }
                return
            }
            
            if newProgramRefs != nil {
                self.addPrograms(newPrograms: newProgramRefs!)
                
                if lastProgramRef != nil {
                    self.lastProgramFetchedRef = lastProgramRef
                }
                
                DispatchQueue.main.async {
                    self.endReached = newProgramRefs!.count < 8
                }
                
                return
            }
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
    
    public func updateLastProgramFetchedRef(workoutRef: QueryDocumentSnapshot) {
        DispatchQueue.main.async {
            self.lastProgramFetchedRef = workoutRef
        }
    }
    
}
