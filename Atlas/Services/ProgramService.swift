//
//  ProgramService.swift
//  Atlas
//
//  Created by Michael Bautista on 5/18/24.
//

import SwiftUI

final class ProgramService {
    
    public static let shared = ProgramService()
    
    // MARK: Save program
    public func saveProgram(purchaseProgramRequest: PurchaseProgramRequest) async throws {
        do {
            try await SupabaseService.shared.supabase
                .from("purchased_programs")
                .insert(purchaseProgramRequest)
                .execute()
        } catch {
            throw error
        }
    }
    
    // MARK: Search programs
    public func searchPrograms(searchText: String) async throws -> [Program] {
        do {
            let programs: [Program] = try await SupabaseService.shared.supabase
                .from("programs")
                .select(
                    """
                        id,
                        title,
                        description,
                        image_url,
                        price,
                        weeks,
                        free,
                        private,
                        created_by:users!programs_created_by_fkey(
                            id,
                            full_name,
                            username
                        )
                    """
                )
                .textSearch("title", query: "'\(searchText)'")
                .execute()
                .value
            
            return programs
        } catch {
            throw error
        }
    }
    
    // MARK: Unsave program
    public func unsaveProgram(programId: String) async throws {
        guard let currentUser = UserService.currentUser else {
            return
        }
        
        do {
            try await SupabaseService.shared.supabase
                .from("purchased_programs")
                .delete()
                .eq("program_id", value: programId)
                .eq("purchased_by", value: currentUser.id)
                .execute()
        } catch {
            throw error
        }
    }
    
    // MARK: Check if user purchased program
    public func checkIfUserPurchasedProgram(programId: String) async throws -> Bool {
        guard let currentUser = UserService.currentUser else {
            return false
        }
        
        do {
            let programs: [ProgramId] = try await SupabaseService.shared.supabase
                .from("purchased_programs")
                .select("id")
                .eq("program_id", value: programId)
                .eq("purchased_by", value: currentUser.id)
                .execute()
                .value
            
            return programs.count > 0
        } catch {
            print(error)
            throw error
        }
    }
    
    // MARK: Get creator's programs
    public func getCreatorsPrograms(userId: String, offset: Int) async throws -> [Program] {
        do {
            let programs: [Program] = try await SupabaseService.shared.supabase
                .from("programs")
                .select(
                    """
                        id,
                        title,
                        description,
                        image_url,
                        price,
                        weeks,
                        free,
                        private,
                        created_by:users!programs_created_by_fkey(
                            id,
                            full_name,
                            username
                        )
                    """
                )
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
    
    // MARK: Get creator's public programs
    public func getCreatorsPublicPrograms(userId: String, offset: Int) async throws -> [Program] {
        do {
            let programs: [Program] = try await SupabaseService.shared.supabase
                .from("programs")
                .select(
                    """
                        id,
                        title,
                        description,
                        image_url,
                        price,
                        weeks,
                        free,
                        private,
                        created_by:users!programs_created_by_fkey(
                            id,
                            full_name,
                            username
                        )
                    """
                )
                .eq("created_by", value: userId)
                .eq("private", value: false)
                .order("created_at", ascending: false)
                .range(from: offset, to: offset + 9)
                .execute()
                .value
            
            return programs
        } catch {
            print(error)
            throw error
        }
    }
    
    // MARK: Get user's purchased programs
    public func getPurchasedPrograms(userId: String, offset: Int) async throws -> [PurchasedProgram] {
        do {
            let programs: [PurchasedProgram] = try await SupabaseService.shared.supabase
                .from("purchased_programs")
                .select(
                    """
                        id,
                        created_by:users!saved_workouts_created_by_fkey(
                            id,
                            full_name,
                            username
                        ),
                        programs(
                            id,
                            title,
                            image_url,
                            description
                        )
                    """
                )
                .eq("purchased_by", value: userId)
                .order("created_at", ascending: false)
                .range(from: offset, to: offset + 9)
                .execute()
                .value
            
            return programs
        } catch {
            print(error)
            throw error
        }
    }
    
    // MARK: Get workout's exercises
    public func getWorkoutExercises(workoutId: String) async throws -> [Exercise] {
        do {
            let exercises: [Exercise] = try await SupabaseService.shared.supabase
                .from("exercises")
                .select(
                    """
                        id,
                        exercise_number,
                        title,
                        sets,
                        reps
                    """
                )
                .eq("workout_id", value: workoutId)
                .single()
                .execute()
                .value
            
            return exercises
        } catch {
            throw error
        }
    }
    
    // MARK: Get program workouts
    public func getProgramWorkouts(programId: String, week: Int) async throws -> [Workout] {
        do {
            let workouts: [Workout] = try await SupabaseService.shared.supabase
                .from("workouts")
                .select(
                    """
                        id,
                        title,
                        description
                    """
                )
                .eq("program_id", value: programId)
                .eq("week", value: week)
                .execute()
                .value
            
            return workouts
        } catch {
            throw error
        }
    }
    
    // MARK: Get program
    public func getProgram(programId: String) async throws -> Program {
        do {
            let program: Program = try await SupabaseService.shared.supabase
                .from("programs")
                .select(
                    """
                        id,
                        title,
                        description,
                        image_url,
                        image_path,
                        price,
                        weeks,
                        free,
                        private,
                        created_by:users!programs_created_by_fkey(
                            id,
                            full_name,
                            username
                        )
                    """
                )
                .eq("id", value: programId)
                .single()
                .execute()
                .value
            
            return program
        } catch {
            throw error
        }
    }
}
