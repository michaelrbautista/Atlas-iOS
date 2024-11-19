//
//  TrainingViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 11/6/24.
//

import SwiftUI
import HealthKit

final class TrainingViewModel: ObservableObject {
    
    // MARK: Variables
    @Published var isLoading = true
    
    @Published var startedProgram: String? = nil
    @Published var startDayAsNumber: Int? = nil
    @Published var startDate: Date? = nil

    @Published var daysSinceStarted: Int? = nil

    @Published var program: Program? = nil
    @Published var workouts: [Workout]? = nil
    
    @Published var nutritionPlan: NutritionPlan? = nil
    @Published var basicActivity = 0
    @Published var nutritionWorkouts = [HealthKitWorkout]()
    @Published var totalCalories = 0
    
    @Published var hasAuthorizedHealthData = false
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage = ""
    
    // MARK: Initializaer
    init() {
        self.startedProgram = UserDefaults.standard.value(forKey: "startedProgram") as? String
        self.startDayAsNumber = UserDefaults.standard.value(forKey: "startDayAsNumber") as? Int
        self.startDate = UserDefaults.standard.value(forKey: "startDate") as? Date
        
        let write: Set<HKSampleType> = [
            .workoutType()
        ]
        
        let read: Set = [
            .workoutType(),
            HKSeriesType.activitySummaryType(),
            HKSeriesType.workoutType()
        ]
        
        HealthKitService.healthStore.getRequestStatusForAuthorization(toShare: write, read: read) { authorizationRequestStatus, error in
            switch authorizationRequestStatus {
            case .shouldRequest:
                DispatchQueue.main.async {
                    self.hasAuthorizedHealthData = false
                }
            case .unknown:
                DispatchQueue.main.async {
                    self.hasAuthorizedHealthData = false
                }
            case .unnecessary:
                DispatchQueue.main.async {
                    self.hasAuthorizedHealthData = true
                }
            default:
                break
            }
        }
        
        Task {
            await getStartedProgram()
            await getNutritionPlan()
        }
    }
    
    @MainActor
    public func addWorkoutCaloriesToTotal(workout: HealthKitWorkout) {
        self.nutritionWorkouts.append(workout)
        self.totalCalories += Int(workout.calories) ?? 0
    }
    
    @MainActor
    func requestPermission() async -> Bool {
        let write: Set<HKSampleType> = [
            .workoutType()
        ]
        
        let read: Set = [
            .workoutType(),
            HKSeriesType.activitySummaryType(),
            HKSeriesType.workoutType()
        ]

        let res: ()? = try? await HealthKitService.healthStore.requestAuthorization(toShare: write, read: read)
        guard res != nil else {
            return false
        }

        self.hasAuthorizedHealthData = true
        return true
    }
    
    @MainActor
    public func refreshHome() {
        self.startedProgram = UserDefaults.standard.value(forKey: "startedProgram") as? String
        self.startDayAsNumber = UserDefaults.standard.value(forKey: "startDayAsNumber") as? Int
        self.startDate = UserDefaults.standard.value(forKey: "startDate") as? Date
        
        self.program = nil
        self.workouts = nil
        self.nutritionPlan = nil

        Task {
            await getStartedProgram()
            await getNutritionPlan()
        }
    }
    
    @MainActor
    public func getNutritionPlan() {
        if let data = UserDefaults.standard.object(forKey: "nutritionPlan") as? Data,
           let userNutritionPlan = try? JSONDecoder().decode(NutritionPlan.self, from: data) {
            nutritionPlan = userNutritionPlan
            
            self.basicActivity = Int(Double(userNutritionPlan.bmr) * 0.2)
            
            self.totalCalories = userNutritionPlan.bmr + self.basicActivity
        } else {
            print("No nutrition plan found.")
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
            self.workouts = [Workout]()

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
