//
//  DayViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 9/12/24.
//

import SwiftUI

final class DayViewModel: ObservableObject {
    
    // MARK: Variables
    var programId: String
    var week: Int
    var day: String
    
    @Published var workouts: [FetchedProgramWorkout]? = nil
    
    @Published var isLoading = true
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage = ""
    
    // MARK: Initializer
    init(programId: String, week: Int, day: String) {
        self.programId = programId
        self.week = week
        self.day = day
        
        Task {
            await getWorkouts()
        }
    }
    
    // MARK: Get program
    @MainActor
    public func getWorkouts() async {
        Task {
            do {
                // Get workouts
                let workouts = try await WorkoutService.shared.getDayWorkouts(programId: programId, week: week, day: day)
                
                self.workouts = workouts
                
                self.isLoading = false
            } catch {
                self.isLoading = false
                self.didReturnError = true
                self.returnedErrorMessage = error.localizedDescription
            }
        }
    }
}
