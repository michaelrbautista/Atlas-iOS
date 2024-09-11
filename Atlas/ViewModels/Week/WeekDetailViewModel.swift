//
//  WeekDetailViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 6/13/24.
//

import SwiftUI

final class WeekDetailViewModel: ObservableObject {
    // MARK: Variables
    var weekNumber: Int
    @Published var workouts: [Workout]?
    
    @Published var mondayWorkouts = [Workout]()
    @Published var tuesdayWorkouts = [Workout]()
    @Published var wednesdayWorkouts = [Workout]()
    @Published var thursdayWorkouts = [Workout]()
    @Published var fridayWorkouts = [Workout]()
    @Published var saturdayWorkouts = [Workout]()
    @Published var sundayWorkouts = [Workout]()
    
    @Published var isLoading: Bool = true
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage = ""
    
    // MARK: Initializer
    init(programId: String, weekNumber: Int) {
        isLoading = true
        
        self.weekNumber = weekNumber
        
        Task {
            do {
                // Get workouts for week
                let workouts = try await WorkoutService.shared.getWeekWorkouts(programId: programId, weekNumber: weekNumber)
                
                DispatchQueue.main.async {
                    self.workouts = workouts
                    
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.didReturnError = true
                    self.returnedErrorMessage = error.localizedDescription
                }
            }
        }
    }
}
