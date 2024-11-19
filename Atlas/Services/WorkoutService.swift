//
//  WorkoutService.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI

final class WorkoutService {
    
    public static let shared = WorkoutService()
    
    // MARK: Get workouts for day
    public func getDayWorkouts(programId: String, week: Int, day: String) async throws -> [Workout] {
        do {
            let workouts: [Workout] = try await SupabaseService.shared.supabase
                .from("workouts")
                .select()
                .eq("program_id", value: programId)
                .eq("week", value: week)
                .eq("day", value: day)
                .execute()
                .value
            
            return workouts
        } catch {
            throw error
        }
    }
    
    // MARK: Get single workout
    public func getWorkout(workoutId: String) async throws -> Workout {
        do {
            let workout: Workout = try await SupabaseService.shared.supabase
                .from("workouts")
                .select("*, workout_exercises(*)")
                .eq("id", value: workoutId)
                .single()
                .execute()
                .value
            
            return workout
        } catch {
            throw error
        }
    }
}
