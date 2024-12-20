//
//  ExerciseService.swift
//  Atlas
//
//  Created by Michael Bautista on 5/20/24.
//

import SwiftUI

final class ExerciseService {
    
    public static let shared = ExerciseService()
    
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
                .select()
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
            print(error)
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
