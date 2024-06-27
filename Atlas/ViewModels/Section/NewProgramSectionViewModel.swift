//
//  NewProgramSectionViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 6/13/24.
//

import SwiftUI

final class NewProgramSectionViewModel: ObservableObject {
    
    // MARK: Section data
    var programId: String
    var sectionNumber: Int
    
    @Published var title: String = ""
    @Published var description: String = ""
    
    @Published var isSaving = false
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage: String? = nil
    
    init(programId: String, sectionNumber: Int) {
        self.programId = programId
        self.sectionNumber = sectionNumber
    }
    
    // MARK: Create new workout
    @MainActor
    public func createNewProgramSection() async -> ProgramSection? {
        isSaving = true
        
        guard let currentUserId = UserService.currentUser?.id.description else {
            self.didReturnError = true
            self.returnedErrorMessage = "Couldn't get current user."
            return nil
        }
        
        let newProgramSection = ProgramSection(
            createdBy: currentUserId,
            programId: programId,
            sectionNumber: sectionNumber,
            title: title,
            description: description
        )
        
        do {
            let createdProgramSection = try await SectionService.shared.createSection(section: newProgramSection)
            
            isSaving = false
            
            return createdProgramSection
        } catch {
            isSaving = false
            self.didReturnError = true
            self.returnedErrorMessage = error.localizedDescription
            print(error)
            return nil
        }
    }
}
