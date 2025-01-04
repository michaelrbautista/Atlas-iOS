//
//  EditProgramWorkoutViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 12/23/24.
//

import SwiftUI

final class EditProgramWorkoutViewModel: ObservableObject {
    @Published var isLoading = false
    
    @Published var workoutId: String? = nil
    @Published var title: String = ""
    @Published var description: String = ""
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage = ""
    
    init(workout: ProgramWorkout) {
        self.workoutId = workout.id
        self.title = workout.title
        self.description = String(workout.description ?? "")
    }
    
    // MARK: Save library workout
    @MainActor
    public func saveProgramWorkout() async -> ProgramWorkout? {
        self.isLoading = true
        
        do {
            let newWorkout = try await WorkoutService.shared.editProgramWorkout(editWorkoutRequest: EditWorkoutRequest(id: self.workoutId!, title: self.title, description: self.description == "" ? nil : self.description))
            
            // Update program on UI
            return newWorkout
        } catch {
            self.isLoading = false
            self.didReturnError = true
            self.returnedErrorMessage = error.localizedDescription
            return nil
        }
    }
}
