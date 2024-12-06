//
//  WorkoutService.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI

final class WorkoutService {
    
    public static let shared = WorkoutService()
    
    // MARK: Get creator's workouts
    public func getCreatorsWorkouts(userId: String, offset: Int) async throws -> [FetchedWorkout] {
        do {
            let workouts: [FetchedWorkout] = try await SupabaseService.shared.supabase
                .from("workouts")
                .select(
                    """
                        id,
                        title,
                        description,
                        program_exercises(
                            id,
                            exercise_number,
                            sets,
                            reps,
                            time,
                            exercises(
                                id,
                                title,
                                instructions,
                                video_url
                            )
                        )
                    """
                )
                .eq("created_by", value: userId)
                .order("created_at", ascending: false)
                .range(from: offset, to: offset + 9)
                .execute()
                .value
            
            return workouts
        } catch {
            throw error
        }
    }
    
    // MARK: Get workouts for day
    public func getDayWorkouts(programId: String, week: Int, day: String) async throws -> [FetchedProgramWorkout] {
        do {
            let workouts: [FetchedProgramWorkout] = try await SupabaseService.shared.supabase
                .from("program_workouts")
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
    public func getWorkout(workoutId: String) async throws -> FetchedProgramWorkout {
        do {
            let workout: FetchedProgramWorkout = try await SupabaseService.shared.supabase
                .from("program_workouts")
                .select(
                    """
                        id,
                        title,
                        description,
                        program_exercises(
                            id,
                            exercise_id,
                            exercise_number,
                            sets,
                            reps,
                            time,
                            exercises(
                                title,
                                instructions,
                                video_url
                            )
                        )
                    """
                )
                .eq("id", value: workoutId)
                .single()
                .execute()
                .value
            
            return workout
        } catch {
            print(error)
            throw error
        }
    }
}
