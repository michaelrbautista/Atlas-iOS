//
//  UserProgramsViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 9/9/24.
//

import SwiftUI

final class UserProgramsViewModel: ObservableObject {
    // MARK: Variables
    @Published var isLoading = true
    @Published var endReached = false
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage: String? = nil
    
    @Published var programs = [Program]()
    
    var userId: String
    
    init(userId: String) {
        self.userId = userId
        
        Task {
            await getUserPrograms()
        }
    }
    
    @MainActor
    public func pulledRefresh() async {
        self.programs = [Program]()
        self.endReached = false
        
        await getUserPrograms()
    }
    
    @MainActor
    public func getUserPrograms() async {
//        do {
//            let programs = try await ProgramService.shared.getTeamPrograms(teamId: self.teamId)
//            
//            self.programs = programs
//            
//            self.isLoading = false
//            
//            if programs.count > 8 {
//                self.endReached = true
//            }
//        } catch {
//            self.isLoading = false
//            self.didReturnError = true
//            self.returnedErrorMessage = error.localizedDescription
//        }
    }
}
