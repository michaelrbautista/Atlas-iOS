//
//  NewLibraryWorkoutViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 12/8/24.
//

import SwiftUI

final class NewLibraryWorkoutViewModel: ObservableObject {
    @Published var isLoading = false
    
    @Published var title = ""
    @Published var description = ""
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage = ""
    
    @MainActor
    public func saveWorkout() async -> FetchedWorkout? {
        self.isLoading = true
        
        // Check fields
        if title == "" {
            didReturnError = true
            returnedErrorMessage = "Please give the workout a title."
            return nil
        }
        
        do {
            let newWorkout = try await WorkoutService.shared.createLibraryWorkout(createWorkoutRequest: CreateWorkoutRequest(title: self.title, description: self.description == "" ? nil : self.description))
            
            return newWorkout
        } catch {
            self.isLoading = false
            self.didReturnError = true
            self.returnedErrorMessage = error.localizedDescription
            return nil
        }
    }
    
}
