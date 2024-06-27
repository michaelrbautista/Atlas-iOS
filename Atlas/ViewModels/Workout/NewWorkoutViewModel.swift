//
//  NewWorkoutViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 5/11/24.
//

import SwiftUI

final class NewWorkoutViewModel: ObservableObject {
    
    // MARK: Workout data
    var sectionId: String
    var workoutNumber: Int
    
    @Published var title: String = ""
    @Published var isFree: Bool = false
    @Published var description: String = ""
    
    @Published var isSaving = false
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage: String? = nil
    
    init(sectionId: String, workoutNumber: Int) {
        self.sectionId = sectionId
        self.workoutNumber = workoutNumber
    }
    
    // MARK: Create new workout
    @MainActor
    public func createNewWorkout() async -> Workout? {
        isSaving = true
        
        guard let currentUserId = UserService.currentUser?.id.description else {
            self.didReturnError = true
            self.returnedErrorMessage = "Couldn't get current user."
            return nil
        }
        
        let newWorkout = Workout(
            createdBy: currentUserId,
            sectionId: sectionId,
            workoutNumber: workoutNumber,
            title: title,
            isFree: isFree,
            description: description
        )
        
        do {
            let createdWorkout = try await WorkoutService.shared.createWorkout(workout: newWorkout)
            
            isSaving = false
            
            return createdWorkout
        } catch {
            isSaving = false
            self.didReturnError = true
            self.returnedErrorMessage = error.localizedDescription
            print(error)
            return nil
        }
    }
}
