//
//  WorkoutDetailViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 5/18/24.
//

import SwiftUI

final class WorkoutDetailViewModel: ObservableObject {
    
    // MARK: Variables
    @Published var workout: Workout?
    
    @Published var workoutIsLoading: Bool = true
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage = ""
    
    // MARK: Initializer
    init(workoutId: String) {
        workoutIsLoading = true
        
        Task {
            do {
                // Get program
                let workout = try await WorkoutService.shared.getWorkout(workoutId: workoutId)
                
                DispatchQueue.main.async {
                    self.workout = workout
                    if workout.exercises == nil {
                        self.workout?.exercises = [Exercise]()
                    }
                    self.workoutIsLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.workoutIsLoading = false
                    self.didReturnError = true
                    self.returnedErrorMessage = error.localizedDescription
                }
            }
        }
    }
}
