//
//  TrainingViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 11/6/24.
//

import SwiftUI

final class TrainingViewModel: ObservableObject {
    
    // MARK: Variables
    @Published var isLoading = true
    
    @Published var startedProgram: String? = nil
    @Published var startDayAsNumber: Int? = nil
    @Published var startDate: Date? = nil

    @Published var daysSinceStarted: Int? = nil

    @Published var program: Program? = nil
    @Published var workouts: [FetchedProgramWorkout]? = nil
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage = ""
    
    // MARK: Initializaer
    init() {
        self.startedProgram = UserDefaults.standard.value(forKey: "startedProgram") as? String
        self.startDayAsNumber = UserDefaults.standard.value(forKey: "startDayAsNumber") as? Int
        self.startDate = UserDefaults.standard.value(forKey: "startDate") as? Date
        
        Task {
            await getStartedProgram()
        }
    }
    
    @MainActor
    public func refreshHome() {
        self.startedProgram = UserDefaults.standard.value(forKey: "startedProgram") as? String
        self.startDayAsNumber = UserDefaults.standard.value(forKey: "startDayAsNumber") as? Int
        self.startDate = UserDefaults.standard.value(forKey: "startDate") as? Date
        
        self.program = nil
        self.workouts = nil

        Task {
            await getStartedProgram()
        }
    }
    
    @MainActor
    public func getStartedProgram() async {
        let days = ["sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"]

        guard let startDate = self.startDate, let startDayAsNumber = self.startDayAsNumber else {
            self.isLoading = false
            return
        }

        let calendar = Calendar(identifier: .gregorian)
        let daysSinceStarted = calendar.numberOfDaysBetween(startDate, and: Date.now)

        let currentDayAsNumber = startDayAsNumber + daysSinceStarted

        do {
            let program = try await ProgramService.shared.getProgram(programId: self.startedProgram!)

            self.program = program
            self.workouts = [FetchedProgramWorkout]()

            let workouts = try await WorkoutService.shared.getDayWorkouts(
                programId: program.id,
                week: (currentDayAsNumber / 7) + 1,
                day: days[currentDayAsNumber % 7]
            )

            self.workouts = workouts

            self.isLoading = false
        } catch {
            self.isLoading = false
            self.didReturnError = true
            self.returnedErrorMessage = "Couldn't get today's workouts."
            return
        }
    }
    
}
