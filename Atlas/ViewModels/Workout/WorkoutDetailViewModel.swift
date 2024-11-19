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
    
    @Published var isLoading: Bool = true
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage = ""
    
    // MARK: Initializer
    init(workoutId: String) {
        isLoading = true
        
        Task {
            do {
                // Get program
                let workout = try await WorkoutService.shared.getWorkout(workoutId: workoutId)
                let sortedExercises = workout.workoutExercises?.sorted { $0.exerciseNumber < $1.exerciseNumber}
                
                let newWorkout = Workout(
                    id: workout.id,
                    createdAt: workout.createdAt,
                    createdBy: workout.createdBy,
                    programId: workout.programId,
                    week: workout.week,
                    day: workout.day,
                    title: workout.title,
                    description: workout.description,
                    isFree: workout.isFree,
                    workoutExercises: sortedExercises
                )
                
                DispatchQueue.main.async {
                    self.workout = newWorkout
                    if workout.workoutExercises == nil {
                        self.workout?.workoutExercises = [WorkoutExercise]()
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
