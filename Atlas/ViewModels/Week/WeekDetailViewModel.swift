//
//  WeekDetailViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 6/13/24.
//

import SwiftUI

final class WeekDetailViewModel: ObservableObject {
    
    // MARK: Variables
    @Published var week: Week?
    
    @Published var isLoading: Bool = true
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage = ""
    
    // MARK: Initializer
    init(weekId: String) {
        isLoading = true
        
        Task {
            do {
                // Get program
                let week = try await WeekService.shared.getWeek(weekId: weekId)
                
                DispatchQueue.main.async {
                    self.week = week
                    if week.workouts == nil {
                        self.week?.workouts = [Workout]()
                    }
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.didReturnError = true
                    self.returnedErrorMessage = error.localizedDescription
                }
            }
        }
    }
}
