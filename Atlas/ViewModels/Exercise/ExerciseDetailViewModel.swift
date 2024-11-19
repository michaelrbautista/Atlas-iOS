//
//  ExerciseDetailViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 5/21/24.
//

import SwiftUI

final class ExerciseDetailViewModel: ObservableObject {
    
    // MARK: Variables
    var workoutExercise: WorkoutExercise
    
    @Published var exercise: Exercise?
    
    @Published var isLoading: Bool = true
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage = ""
    
    // MARK: Initializer
    init(workoutExercise: WorkoutExercise) {
        isLoading = true
        
        self.workoutExercise = workoutExercise
        
        Task {
            do {
                // Get program
                let exercise = try await ExerciseService.shared.getExercise(exerciseId: workoutExercise.exerciseId)
                
                DispatchQueue.main.async {
                    self.exercise = exercise
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
