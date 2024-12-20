//
//  ProgramExerciseDetailViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 12/14/24.
//

import SwiftUI
import AVKit

final class ProgramExerciseDetailViewModel: ObservableObject {
    
    // MARK: Variables
    var exercise: FetchedWorkoutExercise
    
    @Published var player: AVPlayer? = nil
    
    @Published var isLoading: Bool = false
    
    // MARK: Initializer
    init(exercise: FetchedWorkoutExercise) {
        self.exercise = exercise
    }
}
