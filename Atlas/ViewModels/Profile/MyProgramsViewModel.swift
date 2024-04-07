//
//  MyProgramsViewModel.swift
//  stayhard
//
//  Created by Michael Bautista on 3/28/24.
//

import SwiftUI
import FirebaseFirestore

final class MyProgramsViewModel: ObservableObject {
    
    // MARK: Variables
    var lastProgramFetchedRef: QueryDocumentSnapshot? = nil
    @Published var isLoading = false
    @Published var endReached = false
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage: String? = nil
    
    @Published var programs = [SavedProgram]()
    
    init() {
        isLoading = true
        
        guard let currentUserUid = UserService.currentUser?.uid else {
            didReturnError = true
            returnedErrorMessage = "Error getting workouts."
            return
        }
        
        let getProgramsRequest = GetProgramsRequest(
            uid: currentUserUid,
            lastProgramRef: self.lastProgramFetchedRef
        )
        
        Task {
            await getSavedPrograms(getProgramsRequest: getProgramsRequest) { error in
                if let error = error {
                    self.didReturnError = true
                    self.returnedErrorMessage = error.localizedDescription
                    return
                }
                
                self.didReturnError = false
                self.returnedErrorMessage = nil
                self.isLoading = false
            }
        }
    }
    
    public func pulledRefresh() async {
        self.programs = [SavedProgram]()
        self.lastProgramFetchedRef = nil
        
        isLoading = true
        
        guard let currentUserUid = UserService.currentUser?.uid else {
            didReturnError = true
            returnedErrorMessage = "Error getting workouts."
            return
        }
        
        let getProgramsRequest = GetProgramsRequest(
            uid: currentUserUid,
            lastProgramRef: self.lastProgramFetchedRef
        )
        
        await getSavedPrograms(getProgramsRequest: getProgramsRequest) { error in
            if let error = error {
                self.didReturnError = true
                self.returnedErrorMessage = error.localizedDescription
                return
            }
            
            self.isLoading = false
        }
    }
    
    public func getSavedPrograms(getProgramsRequest: GetProgramsRequest, completion: @escaping (_ error: Error?) -> Void) async {
        isLoading = true
        
        await WorkoutService.shared.getSavedPrograms(getProgramsRequest: getProgramsRequest) { newProgramRefs, lastProgramRef, error in
            self.isLoading = false
            
            if let error = error {
                completion(error)
                return
            }
            
            if newProgramRefs != nil {
                self.addPrograms(newPrograms: newProgramRefs!)
                
                if lastProgramRef != nil {
                    self.lastProgramFetchedRef = lastProgramRef
                }
                
                self.endReached = newProgramRefs!.count < 8
                completion(nil)
                return
            }
        }
    }
    
    public func updateProgram(newProgram: SavedProgram, programIndex: Int) {
        self.programs[programIndex] = newProgram
    }
    
    public func insertProgramToBeginning(newProgram: SavedProgram) {
        self.programs.insert(newProgram, at: 0)
    }
    
    public func addPrograms(newPrograms: [SavedProgram]) {
        self.programs.append(contentsOf: newPrograms)
    }
    
    public func removeProgram(programIndex: Int) {
        self.programs.remove(at: programIndex)
    }
    
    public func updateLastProgramFetchedRef(workoutRef: QueryDocumentSnapshot) {
        self.lastProgramFetchedRef = workoutRef
    }
    
}
