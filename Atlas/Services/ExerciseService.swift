//
//  ExerciseService.swift
//  Atlas
//
//  Created by Michael Bautista on 5/20/24.
//

import SwiftUI

final class ExerciseService {
    
    public static let shared = ExerciseService()
    
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
