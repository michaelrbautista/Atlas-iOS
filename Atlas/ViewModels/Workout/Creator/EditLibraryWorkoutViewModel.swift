//
//  EditLibraryWorkoutViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 12/13/24.
//

import SwiftUI

final class EditLibraryWorkoutViewModel: ObservableObject {
    @Published var isLoading = false
    
    @Published var workoutId: String? = nil
    @Published var title: String = ""
    @Published var description: String = ""
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage = ""
    
    init(workout: EditWorkoutRequest) {
        self.workoutId = workout.id
        self.title = workout.title
        self.description = String(workout.description ?? "")
    }
    
    // MARK: Save library workout
    @MainActor
    public func saveLibraryWorkout() async -> FetchedWorkout? {
        self.isLoading = true
        
        do {
            let newWorkout = try await WorkoutService.shared.editLibraryWorkout(editWorkoutRequest: EditWorkoutRequest(id: self.workoutId!, title: self.title, description: self.description == "" ? nil : self.description))
            
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
