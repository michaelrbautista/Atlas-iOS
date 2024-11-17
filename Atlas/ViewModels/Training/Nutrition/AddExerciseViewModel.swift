//
//  AddExerciseViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 9/18/24.
//

import SwiftUI

final class AddExerciseViewModel: ObservableObject {
    
    @Published var exercise = ""
    @Published var duration = ""
    @Published var intensity = ""
    
    @Published var returnedError = false
    @Published var errorMessage = ""
    
    public func addExercise() {
        
    }
    
}
