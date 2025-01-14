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
    @Published var returnedErrorMessage = ""
    
    @Published var programs = [Program]()
    
    var userId: String
    
    init(userId: String) {
        self.userId = userId
    }
    
    @MainActor
    public func pulledRefresh() async {
        self.programs = [Program]()
        
        await getCreatorsPrograms()
    }
    
    @MainActor
    public func getCreatorsPrograms() async {
        do {
            let programs = try await ProgramService.shared.getCreatorsPublicPrograms(userId: self.userId, offset: self.offset)
            
            self.programs.append(contentsOf: programs)
            
            if programs.count < 10 {
                self.endReached = true
            } else {
                self.endReached = false
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
