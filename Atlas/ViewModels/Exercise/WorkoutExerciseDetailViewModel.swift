//
//  WorkoutExerciseDetailViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 12/14/24.
//

import SwiftUI
import AVKit

final class WorkoutExerciseDetailViewModel: ObservableObject {
    
    // MARK: Variables
    @Published var exercise: FetchedWorkoutExercise
    
    @Published var player: AVPlayer? = nil
    
    @Published var isLoading: Bool = false
    
    @Published var exerciseVideo: Data? = nil
    @Published var exerciseVideoIsLoading = false
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage = ""
    
    // MARK: Initializer
    init(exercise: FetchedWorkoutExercise) {
        self.exercise = exercise
    }
}
