//
//  ProgramWorkoutDetailViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 5/18/24.
//

import SwiftUI

final class ProgramWorkoutDetailViewModel: ObservableObject {
    
    // MARK: Variables
    var programWorkoutId: String
    @Published var programWorkout: ProgramWorkout?
    
    var isCreator = false
    
    @Published var isLoading = true
    @Published var isDeleting = false
    
    @Published var didReturnError = false
    @Published var errorMessage = ""
    
    // MARK: Initializer
    init(programWorkoutId: String) {
        self.programWorkoutId = programWorkoutId
    }
    
    // MARK: Get workout
    @MainActor
    public func getProgramWorkout() async {
        do {
            // Get workout
            let workout = try await WorkoutService.shared.getProgramWorkout(programWorkoutId: self.programWorkoutId)
            self.isCreator = workout.createdBy == UserService.currentUser?.id
            
            self.programWorkout = workout
            self.isLoading = false
        } catch {
            self.isLoading = false
            self.didReturnError = true
            self.errorMessage = error.localizedDescription
        }
    }
    
    // MARK: Delete exercise
    @MainActor
    public func deleteExercise(exerciseId: String, exerciseNumber: Int, indexSet: IndexSet) async {
        do {
            // Delete exercise
            try await ExerciseService.shared.deleteWorkoutExercise(exerciseId: exerciseId, deletedExerciseNumber: exerciseNumber, workoutId: nil, programWorkoutId: programWorkout!.id)
            
            self.programWorkout!.workoutExercises!.remove(atOffsets: indexSet)
        } catch {
            self.isLoading = false
            self.didReturnError = true
            self.errorMessage = error.localizedDescription
        }
    }
    
    // MARK: Delete workout
    @MainActor
    public func deleteWorkout() async {
        self.isDeleting = true
        
        do {
            // Delete workout from database
            try await WorkoutService.shared.deleteProgramWorkout(workoutId: self.programWorkout!.id)
            
            self.isDeleting = false
        } catch {
            self.isLoading = false
            self.didReturnError = true
            self.errorMessage = error.localizedDescription
        }
    }
}
