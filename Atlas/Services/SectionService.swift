//
//  ProgramSectionService.swift
//  Atlas
//
//  Created by Michael Bautista on 6/13/24.
//

import SwiftUI

final class SectionService {
    
    public static let shared = SectionService()
    
    // MARK: Update section
    
    
    // MARK: Create section
    public func createSection(section: ProgramSection) async throws -> ProgramSection {
        do {
            let createdSection: ProgramSection = try await supabase
                .from("sections")
                .insert(section)
                .select()
                .single()
                .execute()
                .value
            
            return createdSection
        } catch {
            throw error
        }
    }
    
    // MARK: Get section
    public func getSection(sectionId: String) async throws -> ProgramSection {
        do {
            let section: ProgramSection = try await supabase
                .from("sections")
                .select("*, workouts(*)")
                .eq("id", value: sectionId)
                .single()
                .execute()
                .value
            
            return section
        } catch {
            throw error
        }
    }
}
