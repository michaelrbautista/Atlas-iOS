//
//  ExerciseDetailViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 5/21/24.
//

import SwiftUI

final class ExerciseDetailViewModel: ObservableObject {
    
    // MARK: Variables
    @Published var exercise: Exercise
    
    @Published var exerciseIsLoading: Bool = true
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage = ""
    
    // MARK: Initializer
    init(exercise: Exercise) {
        self.exercise = exercise
    }
    
    #warning("Download video and store it in a variable like with program images on program detail view")
}
