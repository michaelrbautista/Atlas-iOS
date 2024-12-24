//
//  ProgramWorkoutDetailViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 5/18/24.
//

import SwiftUI

final class ProgramWorkoutDetailViewModel: ObservableObject {
    
    // MARK: Variables
    @Published var programWorkout: ProgramWorkout?
    
    var isCreator = false
    
    @Published var isLoading = true
    @Published var isDeleting = false
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage = ""
    
    // MARK: Initializer
    @MainActor
    init(programWorkoutId: String) {
        Task {
            do {
                // Get workout
                let workout = try await WorkoutService.shared.getProgramWorkout(programWorkoutId: programWorkoutId)
                
                self.programWorkout = workout
                self.isCreator = workout.createdBy == UserService.currentUser?.id
                self.isLoading = false
            } catch {
                self.isLoading = false
                self.didReturnError = true
                self.returnedErrorMessage = error.localizedDescription
            }
        }
    }
    
    // MARK: Delete exercise
    @MainActor
    public func deleteExercise(exerciseId: String, indexSet: IndexSet) async {
        do {
            // Delete exercise
            try await ExerciseService.shared.deleteWorkoutExercise(exerciseId: exerciseId)
            
            self.programWorkout!.workoutExercises!.remove(atOffsets: indexSet)
        } catch {
            self.isLoading = false
            self.didReturnError = true
            self.returnedErrorMessage = error.localizedDescription
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
            self.returnedErrorMessage = error.localizedDescription
        }
    }
}
