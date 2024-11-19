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
    
    @Published var offset = 0
    @Published var endReached = false
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage: String? = nil
    
    @Published var programs = [Program]()
    
    var userId: String
    
    init(userId: String) {
        self.userId = userId
        
        Task {
            await getCreatorsPrograms()
        }
    }
    
    @MainActor
    public func pulledRefresh() async {
        self.programs = [Program]()
        self.endReached = false
        
        await getCreatorsPrograms()
    }
    
    @MainActor
    public func getCreatorsPrograms() async {
        do {
            let programs = try await ProgramService.shared.getCreatorsPrograms(userId: self.userId)
            
            self.programs.append(contentsOf: programs)
            
            if programs.count < 10 {
                self.endReached = true
            } else {
                offset += 10
            }
            
            self.isLoading = false
        } catch {
            self.isLoading = false
            self.didReturnError = true
            self.returnedErrorMessage = error.localizedDescription
        }
    }
}
