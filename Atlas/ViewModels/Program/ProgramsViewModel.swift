//
//  WorkoutViewModel.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI

final class ProgramsViewModel: ObservableObject {
    
    // MARK: Variables
    @Published var isLoading = true
    
    @Published var offset = 0
    @Published var endReached = false
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage = ""
    
    @Published var programs = [PurchasedProgram]()
    
    var userId: String
    
    // MARK: Initializaer
    init() {
        guard let currentUserId = UserService.currentUser?.id.description else {
            userId = ""
            self.didReturnError = true
            self.returnedErrorMessage = "Couldn't get current user."
            return
        }
        
        self.userId = currentUserId
        
        Task {
            await getPurchasedPrograms()
        }
    }
    
    // MARK: Refresh
    @MainActor
    public func pulledRefresh() async {
        self.programs = [PurchasedProgram]()
//        self.endReached = false
//        
        await getPurchasedPrograms()
    }
    
    // MARK: Get my saved programs
    @MainActor
    public func getPurchasedPrograms() async {
        do {
            let programs = try await ProgramService.shared.getPurchasedPrograms(userId: self.userId, offset: offset)
            
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
    
    public func addPrograms(newPrograms: [PurchasedProgram]) {
        DispatchQueue.main.async {
            self.programs.append(contentsOf: newPrograms)
        }
    }
    
    public func removeProgram(programIndex: Int) {
        DispatchQueue.main.async {
            self.programs.remove(at: programIndex)
        }
    }
    
}

extension Calendar {
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
        let fromDate = startOfDay(for: from) // <1>
        let toDate = startOfDay(for: to) // <2>
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate) // <3>
        
        return numberOfDays.day!
    }
}
