//
//  ExerciseService.swift
//  Atlas
//
//  Created by Michael Bautista on 5/20/24.
//

import SwiftUI

final class ExerciseService {
    
    public static let shared = ExerciseService()
    
    // MARK: Edit workout exercise
    public func editWorkoutExercise(editExerciseRequest: EditWorkoutExerciseRequest) async throws -> FetchedWorkoutExercise {
        do {
            let newExercise: FetchedWorkoutExercise = try await SupabaseService.shared.supabase
                .from("workout_exercises")
                .update(editExerciseRequest)
                .eq("id", value: editExerciseRequest.id)
                .select(
                    """
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
                    """
                )
                .single()
                .execute()
                .value
            
            return newExercise
        } catch {
            throw error
        }
    }
    
    // MARK: Edit library exercise
    public func editLibraryExercise(editExerciseRequest: EditLibraryExerciseRequest) async throws -> FetchedExercise {
        do {
            let newExercise: FetchedExercise = try await SupabaseService.shared.supabase
                .from("exercises")
                .update(editExerciseRequest)
                .eq("id", value: editExerciseRequest.id)
                .select()
                .single()
                .execute()
                .value
            
            return newExercise
        } catch {
            throw error
        }
    }
    
    // MARK: Add exercise to workout
    public func addExerciseToWorkout(newExercise: NewWorkoutExercise) async throws -> FetchedWorkoutExercise {
        do {
            let exercise: FetchedWorkoutExercise = try await SupabaseService.shared.supabase
                .from("workout_exercises")
                .insert(newExercise)
                .select(
                    """
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
                    """
                )
                .single()
                .execute()
                .value
            
            return exercise
        } catch {
            print(error)
            throw error
        }
    }
    
    // MARK: Copy exercises to program workout
    public func copyExercisesToProgramWorkout(exercises: [NewWorkoutExercise]) async throws {
        do {
            try await SupabaseService.shared.supabase
                .from("workout_exercises")
                .insert(exercises)
                .execute()
        } catch {
            throw error
        }
    }
    
    // MARK: Get workout's exercises
    public func getWorkoutsExercises(workoutId: String) async throws -> [FetchedWorkoutExercise] {
        do {
            let exercises: [FetchedWorkoutExercise] = try await SupabaseService.shared.supabase
                .from("workout_exercises")
                .select()
                .eq("workout_id", value: workoutId)
                .execute()
                .value
            
            return exercises
        } catch {
            throw error
        }
    }
    
    // MARK: Decrement workout's exercises
    public func decrementWorkoutExercises(deletedExerciseNumber: Int, workoutId: String?, programWorkoutId: String?) async throws {
        do {
            if workoutId != nil {
                try await SupabaseService.shared.supabase
                    .rpc("decrement_library_workout_exercises", params: [
                        "workout_id_input": workoutId!,
                        "deleted_exercise_number": String(deletedExerciseNumber)
                    ])
                    .execute()
            } else if programWorkoutId != nil {
                try await SupabaseService.shared.supabase
                    .rpc("decrement_program_workout_exercises", params: [
                        "program_workout_id_input": programWorkoutId!,
                        "deleted_exercise_number": String(deletedExerciseNumber)
                    ])
                    .execute()
            }
        } catch {
            throw error
        }
    }
    
    // MARK: Delete workout exercise
    public func deleteWorkoutExercise(exerciseId: String, deletedExerciseNumber: Int, workoutId: String?, programWorkoutId: String?) async throws {
        do {
            try await SupabaseService.shared.supabase
                .from("workout_exercises")
                .delete()
                .eq("id", value: exerciseId)
                .execute()
            
            try await decrementWorkoutExercises(deletedExerciseNumber: deletedExerciseNumber, workoutId: workoutId, programWorkoutId: programWorkoutId)
        } catch {
            throw error
        }
    }
    
    // MARK: Delete library exercise
    public func deleteLibraryExercise(exerciseId: String) async throws {
        do {
            try await SupabaseService.shared.supabase
                .from("exercises")
                .delete()
                .eq("id", value: exerciseId)
                .execute()
        } catch {
            throw error
        }
    }
    
    // MARK: Create library exercise
    public func createLibraryExercise(createExerciseRequest: CreateExerciseRequest) async throws -> FetchedExercise {
        do {
            let newExercise: FetchedExercise = try await SupabaseService.shared.supabase
                .from("exercises")
                .insert(createExerciseRequest)
                .select()
                .single()
                .execute()
                .value
            
            return newExercise
        } catch {
            throw error
        }
    }
    
    // MARK: Get creator's exercises
    public func getCreatorsExercises(userId: String, offset: Int) async throws -> [FetchedExercise] {
        do {
            let programs: [FetchedExercise] = try await SupabaseService.shared.supabase
                .from("exercises")
                .select()
                .eq("created_by", value: userId)
                .order("created_at", ascending: false)
                .range(from: offset, to: offset + 9)
                .execute()
                .value
            
            return programs
        } catch {
            throw error
        }
    }
    
    // MARK: Get exercise
    public func getExercise(exerciseId: String) async throws -> Exercise {
        do {
            let exercise: Exercise = try await SupabaseService.shared.supabase
                .from("exercises")
                .select()
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
