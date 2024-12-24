//
//  EditWorkoutExerciseViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 12/23/24.
//

import SwiftUI

final class EditWorkoutExerciseViewModel: ObservableObject {
    @Published var isSaving = false
    
    @Published var workoutExerciseId: String
    var exercise: FetchedWorkoutExercise
    var videoUrl: URL?
    @Published var sets = ""
    @Published var reps = ""
    @Published var time = ""
    @Published var other = ""
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage = ""
    
    // MARK: Initializer
    init(exercise: FetchedWorkoutExercise) {
        self.exercise = exercise
        self.workoutExerciseId = exercise.id
        self.sets = String(exercise.sets ?? 1)
        self.reps = String(exercise.reps ?? 1)
        self.time = exercise.time ?? ""
        self.other = exercise.other ?? ""
        
        if let exerciseVideoUrl = exercise.exercises?.videoUrl {
            self.videoUrl = URL(string: exerciseVideoUrl)
        }
    }
    
    // MARK: Save exercise
    @MainActor
    public func saveExercise() async -> FetchedWorkoutExercise? {
        self.isSaving = true
        
        // Check fields
        if sets == "" || reps == "" {
            didReturnError = true
            returnedErrorMessage = "Please fill in all fields"
            return nil
        }
        
        do {
            let editExerciseRequest = EditWorkoutExerciseRequest(
                id: self.workoutExerciseId,
                sets: Int(self.sets) ?? 1,
                reps: Int(self.reps) ?? 1,
                time: self.time,
                other: self.other
            )
            
            // Update exercise
            let editedExercise = try await ExerciseService.shared.editWorkoutExercise(editExerciseRequest: editExerciseRequest)
            
            // Update program on UI
            return editedExercise
        } catch {
            self.isSaving = false
            self.didReturnError = true
            self.returnedErrorMessage = error.localizedDescription
            return nil
        }
    }
}
