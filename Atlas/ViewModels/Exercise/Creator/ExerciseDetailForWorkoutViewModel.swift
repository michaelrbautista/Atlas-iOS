//
//  ExerciseDetailForWorkoutViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 12/15/24.
//

import SwiftUI
import AVKit

final class ExerciseDetailForWorkoutViewModel: ObservableObject {
    
    var workoutId: String?
    var programWorkoutId: String?
    var exercise: FetchedExercise
    var exerciseNumber: Int
    
    @Published var sets = ""
    @Published var reps = ""
    @Published var time = ""
    @Published var other = ""
    
    @Published var player: AVPlayer? = nil
    
    @Published var isAdding = false
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage = ""
    
    init(workoutId: String?, programWorkoutId: String?, exercise: FetchedExercise, exerciseNumber: Int) {
        self.workoutId = workoutId
        self.programWorkoutId = programWorkoutId
        self.exercise = exercise
        self.exerciseNumber = exerciseNumber
    }
    
    @MainActor
    public func addExerciseToWorkout() async -> FetchedWorkoutExercise? {
        // Check fields
        if sets == "" || reps == "" {
            self.isAdding = false
            self.didReturnError = true
            self.returnedErrorMessage = "Sets and reps must be filled in."
            return nil
        }
        
        // Create new workout exercise object
        let newExercise = NewWorkoutExercise(
            programWorkoutId: self.programWorkoutId,
            workoutId: self.workoutId,
            exerciseId: self.exercise.id,
            exerciseNumber: self.exerciseNumber,
            sets: Int(self.sets) ?? 1,
            reps: Int(self.reps) ?? 1,
            time: self.time,
            other: self.other
        )
        
        self.isAdding = true
        
        // Save to workout_exercises table
        do {
            let exercise: FetchedWorkoutExercise = try await ExerciseService.shared.addExerciseToWorkout(newExercise: newExercise)
            
            return exercise
        } catch {
            self.isAdding = false
            self.didReturnError = true
            self.returnedErrorMessage = error.localizedDescription
            return nil
        }
    }
}
