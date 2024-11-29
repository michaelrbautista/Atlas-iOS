//
//  WorkoutDetailViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 5/18/24.
//

import SwiftUI

final class WorkoutDetailViewModel: ObservableObject {
    
    // MARK: Variables
    @Published var workout: FetchedProgramWorkout?
    
    @Published var isLoading: Bool = true
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage = ""
    
    // MARK: Initializer
    init(workoutId: String) {
        isLoading = true
        
        Task {
            do {
                // Get workout
                let workout = try await WorkoutService.shared.getWorkout(workoutId: workoutId)
                
                DispatchQueue.main.async {
                    self.workout = workout
                    if workout.programExercises == nil {
                        self.workout?.programExercises = [FetchedProgramExercise]()
                    }
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.didReturnError = true
                    self.returnedErrorMessage = error.localizedDescription
                }
            }
        }
    }
}
