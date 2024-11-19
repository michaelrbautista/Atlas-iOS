//
//  AddWorkoutViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 11/10/24.
//

import SwiftUI
import HealthKit

final class AddWorkoutViewModel: ObservableObject {
    
    @Published var isLoading = false
    @Published var workouts = [HealthKitWorkout]()
    
    init() {
//        addWorkout()
        
        Task {
            await readWorkouts()
        }
    }
    
    @MainActor
    func readWorkouts() async {
        self.isLoading = true

        do {
            let samples = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[HKSample], Error>) in
                HealthKitService.healthStore.execute(HKSampleQuery(sampleType: .workoutType(), predicate: nil, limit: HKObjectQueryNoLimit,sortDescriptors: [.init(keyPath: \HKSample.startDate, ascending: false)], resultsHandler: { query, samples, error in
                    if let hasError = error {
                        continuation.resume(throwing: hasError)
                        self.isLoading = false
                        return
                    }
                    
                    guard let samples = samples else {
                        self.isLoading = false
                        fatalError("*** Invalid State: This can only fail if there was an error. ***")
                    }
                    
                    continuation.resume(returning: samples)
                }))
            }
            
            guard let workouts = samples as? [HKWorkout] else {
                self.isLoading = false
                return
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            
            guard let quantityType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned) else {
                print("Couldn't create calorie type for HealthKit.")
                return
            }
            
            for workout in workouts {
                let workoutType = String(describing: workout.workoutActivityType.name)
                let formattedDate = dateFormatter.string(from: workout.startDate)
                let caloriesInt = workout.statistics(for: quantityType)?.sumQuantity()
                
                if let calories = caloriesInt {
                    let caloriesNumber = calories.description.components(separatedBy: " ")[0]
                    
                    let newWorkout = HealthKitWorkout(
                        type: workoutType,
                        date: formattedDate,
                        calories: caloriesNumber
                    )
                    
                    self.workouts.append(newWorkout)
                }
            }
            
            self.isLoading = false
        } catch {
            print(error)
            self.isLoading = false
            return
        }
    }
    
    public func addWorkout() {
        let energyBurned = HKQuantity(unit: HKUnit.largeCalorie(), doubleValue: 425.0)
        let distance = HKQuantity(unit: HKUnit.mile(), doubleValue: 3.2)
        
        let startDate = Date.distantPast
        
        let run = HKWorkout(activityType: HKWorkoutActivityType.running,
                            start: startDate,
                            end: startDate.addingTimeInterval(5 * 60),
                            duration: 0,
                            totalEnergyBurned: energyBurned,
                            totalDistance: distance,
                            metadata: nil)
        
        HealthKitService.healthStore.save(run) { (success, error) -> Void in
            guard success else {
                // Perform proper error handling here.
                print(error?.localizedDescription ?? "Couldn't save workout.")
                return
            }
            
            // Add detail samples here.
            print("Workout saved.")
        }
    }
    
}

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
}

extension HKWorkoutActivityType {
    
    /*
     Simple mapping of available workout types to a human readable name.
     */
    var name: String {
        switch self {
        case .americanFootball:             return "American Football"
        case .australianFootball:           return "Australian Football"
        case .badminton:                    return "Badminton"
        case .baseball:                     return "Baseball"
        case .basketball:                   return "Basketball"
        case .bowling:                      return "Bowling"
        case .boxing:                       return "Boxing"
        case .climbing:                     return "Climbing"
        case .crossTraining:                return "Cross Training"
        case .cycling:                      return "Cycling"
        case .elliptical:                   return "Elliptical"
        case .fencing:                      return "Fencing"
        case .fishing:                      return "Fishing"
        case .functionalStrengthTraining:   return "Strength Training"
        case .golf:                         return "Golf"
        case .gymnastics:                   return "Gymnastics"
        case .handball:                     return "Handball"
        case .hiking:                       return "Hiking"
        case .hockey:                       return "Hockey"
        case .hunting:                      return "Hunting"
        case .lacrosse:                     return "Lacrosse"
        case .martialArts:                  return "Martial Arts"
        case .mixedMetabolicCardioTraining: return "Mixed Metabolic Cardio Training"
        case .paddleSports:                 return "Paddle Sports"
        case .racquetball:                  return "Racquetball"
        case .rowing:                       return "Rowing"
        case .rugby:                        return "Rugby"
        case .running:                      return "Run"
        case .skatingSports:                return "Skating Sports"
        case .snowSports:                   return "Snow Sports"
        case .soccer:                       return "Soccer"
        case .softball:                     return "Softball"
        case .squash:                       return "Squash"
        case .stairClimbing:                return "Stair Climbing"
        case .surfingSports:                return "Surfing"
        case .swimming:                     return "Swimming"
        case .tableTennis:                  return "Table Tennis"
        case .tennis:                       return "Tennis"
        case .trackAndField:                return "Track and Field"
        case .traditionalStrengthTraining:  return "Strength Training"
        case .volleyball:                   return "Volleyball"
        case .walking:                      return "Walking"
        case .waterFitness:                 return "Water Fitness"
        case .waterPolo:                    return "Water Polo"
        case .waterSports:                  return "Water Sports"
        case .wrestling:                    return "Wrestling"
        case .yoga:                         return "Yoga"
        default:                            return "Other"
        }
    }
}
