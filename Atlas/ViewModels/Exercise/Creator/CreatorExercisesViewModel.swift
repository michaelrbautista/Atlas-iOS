//
//  CreatorExercisesViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 12/5/24.
//

import SwiftUI

final class CreatorExercisesViewModel: ObservableObject {
    @Published var isLoading = true
    
    @Published var offset = 0
    @Published var endReached = false
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage = ""
    
    @Published var exercises = [FetchedExercise]()
    
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
            await getCreatorsExercises()
        }
    }
    
    // MARK: Refresh
    @MainActor
    public func pulledRefresh() async {
        self.exercises = [FetchedExercise]()
        
        await getCreatorsExercises()
    }
    
    // MARK: Get my saved programs
    @MainActor
    public func getCreatorsExercises() async {
        do {
            let exercises = try await ExerciseService.shared.getCreatorsExercises(userId: self.userId, offset: self.offset)
            
            self.exercises.append(contentsOf: exercises)
            
            if exercises.count < 10 {
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
