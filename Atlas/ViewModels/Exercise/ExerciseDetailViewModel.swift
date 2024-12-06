//
//  ExerciseDetailViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 5/21/24.
//

import SwiftUI

final class ExerciseDetailViewModel: ObservableObject {
    
    // MARK: Variables
    var programExercise: FetchedProgramExercise
    
    @Published var exercise: Exercise?
    
    @Published var isLoading: Bool = true
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage = ""
    
    // MARK: Initializer
    init(programExercise: FetchedProgramExercise) {
        isLoading = true
        
        self.programExercise = programExercise
        
        Task {
//            do {
//                // Get program
//                let exercise = try await ExerciseService.shared.getExercise(exerciseId: programExercise.exerciseId)
//                
//                DispatchQueue.main.async {
//                    self.exercise = exercise
//                    self.isLoading = false
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    self.isLoading = false
//                    self.didReturnError = true
//                    self.returnedErrorMessage = error.localizedDescription
//                }
//            }
        }
    }
}
