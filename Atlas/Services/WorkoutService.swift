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
                        created_by,
                        title,
                        description
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
    public func getDayWorkouts(programId: String, week: Int, day: String) async throws -> [ProgramWorkout] {
        do {
            let workouts: [ProgramWorkout] = try await SupabaseService.shared.supabase
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
    
    // MARK: Get library workout
    public func getLibraryWorkout(libraryWorkoutId: String) async throws -> FetchedWorkout {
        do {
            let workout: FetchedWorkout = try await SupabaseService.shared.supabase
                .from("workouts")
                .select(
                    """
                        id,
                        created_by,
                        title,
                        description,
                        workout_exercises(
                            id,
                            created_by,
                            exercise_id,
                            exercise_number,
                            sets,
                            reps,
                            time,
                            other,
                            exercises(
                                id,
                                created_by,
                                title,
                                instructions,
                                video_url
                            )
                        )
                    """
                )
                .eq("id", value: libraryWorkoutId)
                .order("exercise_number", ascending: true, referencedTable: "workout_exercises")
                .single()
                .execute()
                .value
            
            return workout
        } catch {
            print(error)
            throw error
        }
    }
    
    // MARK: Get program workout
    public func getProgramWorkout(programWorkoutId: String) async throws -> ProgramWorkout {
        do {
            let workout: ProgramWorkout = try await SupabaseService.shared.supabase
                .from("program_workouts")
                .select(
                    """
                        id,
                        created_by,
                        title,
                        description,
                        workout_exercises(
                            id,
                            created_by,
                            exercise_id,
                            exercise_number,
                            sets,
                            reps,
                            time,
                            other,
                            exercises(
                                id,
                                created_by,
                                title,
                                instructions,
                                video_url
                            )
                        )
                    """
                )
                .eq("id", value: programWorkoutId)
                .order("exercise_number", ascending: true, referencedTable: "workout_exercises")
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
