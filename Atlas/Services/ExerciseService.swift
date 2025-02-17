//
//  ExerciseService.swift
//  Atlas
//
//  Created by Michael Bautista on 5/20/24.
//

import SwiftUI

final class ExerciseService {
    
    public static let shared = ExerciseService()
    
    // MARK: Get workout's exercises
    public func getWorkoutsExercises(workoutId: String) async throws -> [FetchedWorkoutExercise] {
        do {
            let exercises: [FetchedWorkoutExercise] = try await SupabaseService.shared.supabase
                .from("workout_exercises")
                .select(
                    """
                        id,
                        created_by,
                        title,
                        instructions,
                        video_url,
                        video_path
                    """
                )
                .eq("workout_id", value: workoutId)
                .execute()
                .value
            
            return exercises
        } catch {
            throw error
        }
    }
    
    // MARK: Get exercise
    public func getExercise(exerciseId: String) async throws -> Exercise {
        do {
            let exercise: Exercise = try await SupabaseService.shared.supabase
                .from("exercises")
                .select(
                    """
                        id,
                        created_at,
                        created_by,
                        title,
                        instructions,
                        video_url,
                        video_path
                    """
                )
                .eq("id", value: exerciseId)
                .single()
                .execute()
                .value
            
            return exercise
        } catch {
            throw error
        }
    }
}
