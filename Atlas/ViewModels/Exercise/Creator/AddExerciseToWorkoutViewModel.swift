//
//  AddExerciseToWorkoutViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 12/15/24.
//

import SwiftUI

final class AddExerciseToWorkoutViewModel: ObservableObject {
    
    @Published var isLoading = true
    
    var workoutId: String?
    var programWorkoutId: String?
    var exerciseNumber: Int
    
    var userId: String
    
    @Published var offset = 0
    @Published var endReached = false
    
    @Published var exercises = [FetchedExercise]()
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage = ""
    
    @MainActor
    init(workoutId: String?, programWorkoutId: String?, exerciseNumber: Int) {
        guard let currentUserId = UserService.currentUser?.id.description else {
            userId = ""
            self.exerciseNumber = 0
            self.didReturnError = true
            self.returnedErrorMessage = "Couldn't get current user."
            return
        }
        
        self.workoutId = workoutId
        self.programWorkoutId = programWorkoutId
        self.exerciseNumber = exerciseNumber
        
        self.userId = currentUserId
        
        Task {
            await getCreatorsExercises()
        }
    }
    
    // MARK: Refresh
    @MainActor
    public func pulledRefresh() async {
        self.exercises = [FetchedExercise]()
        
        await getCreatorsExercises()
    }
    
    // MARK: Get my saved programs
    @MainActor
    public func getCreatorsExercises() async {
        do {
            let exercises = try await ExerciseService.shared.getCreatorsExercises(userId: self.userId, offset: self.offset)
            
            self.exercises.append(contentsOf: exercises)
            
            if exercises.count < 10 {
                self.endReached = true
            } else {
                self.endReached = false
                offset += 10
            }
            
            self.isLoading = false
        } catch {
            self.isLoading = false
            self.didReturnError = true
            self.returnedErrorMessage = error.localizedDescription
        }
    }
    
}
