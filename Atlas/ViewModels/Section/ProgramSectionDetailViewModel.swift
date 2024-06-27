//
//  ProgramSectionDetailViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 6/13/24.
//

import SwiftUI

final class ProgramSectionDetailViewModel: ObservableObject {
    
    // MARK: Variables
    @Published var section: ProgramSection?
    
    @Published var sectionIsLoading: Bool = true
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage = ""
    
    // MARK: Initializer
    init(sectionId: String) {
        sectionIsLoading = true
        
        Task {
            do {
                // Get program
                let section = try await SectionService.shared.getSection(sectionId: sectionId)
                
                DispatchQueue.main.async {
                    self.section = section
                    if section.workouts == nil {
                        self.section?.workouts = [Workout]()
                    }
                    self.sectionIsLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.sectionIsLoading = false
                    self.didReturnError = true
                    self.returnedErrorMessage = error.localizedDescription
                }
            }
        }
    }
}
