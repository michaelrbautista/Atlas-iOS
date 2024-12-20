//
//  CreatorWorkoutsView.swift
//  Atlas
//
//  Created by Michael Bautista on 12/6/24.
//

import SwiftUI

final class CreatorWorkoutsViewModel: ObservableObject {
    @Published var isLoading = true
    
    @Published var offset = 0
    @Published var endReached = false
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage = ""
    
    @Published var workouts = [FetchedWorkout]()
    
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
            await getCreatorsPrograms()
        }
    }
    
    // MARK: Refresh
    @MainActor
    public func pulledRefresh() async {
        self.workouts = [FetchedWorkout]()
        
        await getCreatorsPrograms()
    }
    
    // MARK: Get my saved programs
    @MainActor
    public func getCreatorsPrograms() async {
        do {
            let workouts = try await WorkoutService.shared.getCreatorsWorkouts(userId: self.userId, offset: self.offset)
            
            self.workouts.append(contentsOf: workouts)
            
            if workouts.count < 10 {
                self.endReached = true
            } else {
                self.endReached = true
                offset += 10
            }
            
            self.isLoading = false
        } catch {
            print(error)
            self.isLoading = false
            self.didReturnError = true
            self.returnedErrorMessage = error.localizedDescription
        }
    }
}

