//
//  NewProgramWorkoutViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 12/8/24.
//

import SwiftUI

final class NewProgramWorkoutViewModel: ObservableObject {
    @Published var isSaving = false
    
    var programId: String
    var week: Int
    var day: String
    
    @Published var title: String = ""
    @Published var description: String = ""
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage = ""
    
    init(programId: String, week: Int, day: String) {
        self.programId = programId
        self.week = week
        self.day = day
    }
    
    // Add workout
    @MainActor
    public func addNewWorkout() async -> ProgramWorkout? {
        self.isSaving = true
        
        // Check fields
        if title == "" {
            didReturnError = true
            returnedErrorMessage = "Please give the workout a title."
            return nil
        }
        
        do {
            let newWorkout = try await WorkoutService.shared.saveNewWorkoutToProgram(
                workout: addWorkoutToProgramRequest(
                    title: self.title,
                    description: self.description,
                    programId: self.programId,
                    week: self.week,
                    day: self.day
                )
            )
            
            return newWorkout
        } catch {
            self.isSaving = false
            self.didReturnError = true
            self.returnedErrorMessage = error.localizedDescription
            return nil
        }
    }
}
