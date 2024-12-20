//
//  EditWorkoutViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 12/13/24.
//

import SwiftUI

final class EditWorkoutViewModel: ObservableObject {
    @Published var isLoading = false
    
    @Published var isProgramWorkout: Bool
    @Published var workoutId: String? = nil
    @Published var title: String = ""
    @Published var description: String = ""
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage = ""
    
    init(isProgramWorkout: Bool, workout: EditWorkoutRequest) {
        self.isProgramWorkout = isProgramWorkout
        self.workoutId = workout.id
        self.title = workout.title
        self.description = String(workout.description ?? "")
    }
    
    // MARK: Save workout
    @MainActor
    public func saveWorkout() async {
        self.isLoading = true
        
        do {
            var newWorkout: FetchedWorkout
            
            if self.isProgramWorkout {
                // Update library workout
                newWorkout = try await WorkoutService.shared.editWorkout(isProgramWorkout: self.isProgramWorkout, editWorkoutRequest: EditWorkoutRequest(id: self.workoutId!, title: self.title, description: self.description == "" ? nil : self.description))
            } else {
                // Update program workout
                newWorkout = try await WorkoutService.shared.editWorkout(isProgramWorkout: self.isProgramWorkout, editWorkoutRequest: EditWorkoutRequest(id: self.workoutId!, title: self.title, description: self.description == "" ? nil : self.description))
            }
            
            // Update program on UI
            print(newWorkout)
        } catch {
            self.isLoading = false
            self.didReturnError = true
            self.returnedErrorMessage = error.localizedDescription
        }
    }
}
