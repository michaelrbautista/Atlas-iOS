//
//  LibraryWorkoutsForProgramViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 12/8/24.
//

import SwiftUI

final class LibraryWorkoutsForProgramViewModel: ObservableObject {
    
    @Published var isLoading = true
    
    var programId: String
    var week: Int
    var day: String
    
    var userId: String
    
    @Published var offset = 0
    @Published var endReached = false
    
    @Published var workouts = [FetchedWorkout]()
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage = ""
    
    init(programId: String, week: Int, day: String) {
        guard let currentUserId = UserService.currentUser?.id.description else {
            self.userId = ""
            self.programId = ""
            self.week = 0
            self.day = ""
            self.didReturnError = true
            self.returnedErrorMessage = "Couldn't get current user."
            return
        }
        
        self.userId = currentUserId
        self.programId = programId
        self.week = week
        self.day = day
        
        Task {
            await getCreatorsPrograms()
        }
    }
    
    // MARK: Refresh
    @MainActor
    public func pulledRefresh() async {
        self.workouts = [FetchedWorkout]()
        
        await getCreatorsPrograms()
    }
    
    @MainActor
    public func getCreatorsPrograms() async {
        do {
            let workouts = try await WorkoutService.shared.getCreatorsWorkouts(userId: self.userId, offset: self.offset)
            
            self.workouts.append(contentsOf: workouts)
            
            if workouts.count < 10 {
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
