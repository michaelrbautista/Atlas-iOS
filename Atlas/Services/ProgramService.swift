//
//  ProgramService.swift
//  Atlas
//
//  Created by Michael Bautista on 5/18/24.
//

import SwiftUI

final class ProgramService {
    
    public static let shared = ProgramService()
    
    // MARK: Delete program
    public func deleteProgram(programId: String) async throws {
        do {
            try await SupabaseService.shared.supabase
                .from("programs")
                .delete()
                .eq("id", value: programId)
                .execute()
        } catch {
            throw(error)
        }
    }
    
    // MARK: Edit program
    public func editProgram(programId: String, editProgramRequest: EditProgramRequest) async throws -> Program {
        do {
            let editedProgram: Program = try await SupabaseService.shared.supabase
                .from("programs")
                .update(editProgramRequest)
                .eq("id", value: programId)
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
                            full_name
                        )
                    """
                )
                .single()
                .execute()
                .value
            
            return editedProgram
        } catch {
            throw error
        }
    }
    
    // MARK: Create program
    public func createProgram(createProgramRequest: CreateProgramRequest) async throws -> Program {
        do {
            let newProgram: Program = try await SupabaseService.shared.supabase
                .from("programs")
                .insert(createProgramRequest)
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
                            full_name
                        )
                    """
                )
                .single()
                .execute()
                .value
            
            try await SupabaseService.shared.supabase
                .from("purchased_programs")
                .insert(PurchaseProgramRequest(
                    programId: newProgram.id,
                    createdBy: newProgram.createdBy?.id ?? ""
                ))
                .execute()
            
            return newProgram
        } catch {
            throw error
        }
    }
    
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
                .select()
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
                            full_name
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
                            full_name
                        ),
                        programs(
                            id,
                            title,
                            price,
                            image_url
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
                .select()
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
                .select()
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
                            full_name
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
