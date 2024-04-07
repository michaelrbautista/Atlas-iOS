//
//  UserProgramsViewModel.swift
//  stayhard
//
//  Created by Michael Bautista on 3/26/24.
//

import SwiftUI
import FirebaseFirestore

final class UserProgramsViewModel: ObservableObject {
    
    // MARK: Variables
    var lastProgramFetchedRef: QueryDocumentSnapshot? = nil
    @Published var isLoading = false
    @Published var endReached = false
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage: String? = nil
    
    var creatorUid: String
    @Published var programs = [SavedProgram]()
    
    init(creatorUid: String) {
        self.creatorUid = creatorUid
        
        self.isLoading = true
        
        let getProgramsRequest = GetProgramsRequest(
            uid: creatorUid,
            lastProgramRef: self.lastProgramFetchedRef
        )
        
        Task {
            await getCreatorPrograms(getProgramsRequest: getProgramsRequest)
        }
    }
    
    public func pulledRefresh() async {
        DispatchQueue.main.async {
            self.programs = [SavedProgram]()
        }
        
        self.lastProgramFetchedRef = nil
        
        let getProgramsRequest = GetProgramsRequest(
            uid: self.creatorUid,
            lastProgramRef: self.lastProgramFetchedRef
        )
        
        await getCreatorPrograms(getProgramsRequest: getProgramsRequest)
    }
    
    public func getCreatorPrograms(getProgramsRequest: GetProgramsRequest) async {
        await WorkoutService.shared.getCreatorPrograms(getProgramsRequest: getProgramsRequest) { newProgramRefs, lastProgramRef, error in
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
