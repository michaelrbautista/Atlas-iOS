//
//  LibraryWorkoutDetailViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 5/18/24.
//

import SwiftUI

final class LibraryWorkoutDetailViewModel: ObservableObject {
    
    // MARK: Variables
    @Published var libraryWorkout: FetchedWorkout?
    
    var isCreator = false
    
    @Published var isLoading = true
    @Published var isDeleting = false
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage = ""
    
    // MARK: Initializer
    @MainActor
    init(libraryWorkoutId: String) {
        Task {
            do {
                // Get workout
                let workout = try await WorkoutService.shared.getLibraryWorkout(libraryWorkoutId: libraryWorkoutId)
                
                self.libraryWorkout = workout
                self.isCreator = workout.createdBy == UserService.currentUser?.id
                self.isLoading = false
            } catch {
                self.isLoading = false
                self.didReturnError = true
                self.returnedErrorMessage = error.localizedDescription
            }
        }
    }
    
    @MainActor
    public func deleteWorkout() async {
        self.isDeleting = true
        do {
            try await WorkoutService.shared.deleteLibraryWorkout(workoutId: self.libraryWorkout!.id)
        } catch {
            self.isLoading = false
            self.didReturnError = true
            self.returnedErrorMessage = error.localizedDescription
        }
    }
}
