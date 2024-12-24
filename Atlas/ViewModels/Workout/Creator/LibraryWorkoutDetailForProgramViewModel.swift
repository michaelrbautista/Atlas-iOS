//
//  LibraryWorkoutDetailForProgramViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 12/15/24.
//

import SwiftUI

final class LibraryWorkoutDetailForProgramViewModel: ObservableObject {
    
    @Published var workout: FetchedWorkout?
    
    var programId: String
    var week: Int
    var day: String
    
    @Published var isLoading = false
    @Published var isAdding = false
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage = ""
    
    @MainActor
    init(workoutId: String, programId: String, week: Int, day: String) {
        self.programId = programId
        self.week = week
        self.day = day
        
        isLoading = true
        
        Task {
            do {
                // Get workout
                let workout = try await WorkoutService.shared.getLibraryWorkout(libraryWorkoutId: workoutId)
                
                self.workout = workout
                if workout.workoutExercises == nil {
                    self.workout?.workoutExercises = [FetchedWorkoutExercise]()
                }
                self.isLoading = false
            } catch {
                self.isLoading = false
                self.didReturnError = true
                self.returnedErrorMessage = error.localizedDescription
            }
        }
    }
    
    @MainActor
    public func addWorkoutToProgram() async -> ProgramWorkout? {
        self.isAdding = true
        
        do {
            // addProgramWorkoutRequest
            let workoutRequest = addWorkoutToProgramRequest(
                title: workout!.title,
                description: workout!.description,
                programId: programId,
                week: week,
                day: day
            )
            
            // Save to program_workouts table
            let newWorkout = try await WorkoutService.shared.saveLibraryWorkoutToProgram(addLibraryWorkoutToProgramRequest: workoutRequest)
            
            // Copy exercises from library workout, add program_workout_id field
            var newExercises = [NewWorkoutExercise]()
            
            let exercises = try await ExerciseService.shared.getWorkoutsExercises(workoutId: workout!.id)
            
            for exercise in exercises {
                let tempExercise = NewWorkoutExercise(
                    programWorkoutId: newWorkout.id,
                    exerciseId: exercise.exerciseId,
                    exerciseNumber: exercise.exerciseNumber,
                    sets: exercise.sets ?? 1,
                    reps: exercise.reps ?? 1,
                    time: exercise.time,
                    other: exercise.other
                )
                newExercises.append(tempExercise)
            }
            
            // Save exercises to workout_exercises table
            if newExercises.count > 0 {
                try await ExerciseService.shared.copyExercisesToProgramWorkout(exercises: newExercises)
            }
            
            return newWorkout
        } catch {
            self.isAdding = false
            self.didReturnError = true
            self.returnedErrorMessage = error.localizedDescription
            return nil
        }
    }
    
}
