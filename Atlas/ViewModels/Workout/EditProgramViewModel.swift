//
//  EditProgramViewModel.swift
//  stayhard
//
//  Created by Michael Bautista on 4/1/24.
//

import SwiftUI
import PhotosUI

final class EditProgramViewModel: ObservableObject {
    
    // MARK: Variables
    @Published var programImage: UIImage
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            setImage(selection: imageSelection)
        }
    }
    
    @Published var program: Program
    @Published var programTitle: String
    @Published var programDescription: String
    @Published var programWorkouts: [Workout]
    
    @Published var isSaving = false
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage: String? = nil
    
    // MARK: Initializer
    init(programImage: UIImage, program: Program, programTitle: String, programDescription: String, programWorkouts: [Workout]) {
        self.programImage = programImage
        self.program = program
        self.programTitle = programTitle
        self.programDescription = programDescription
        self.programWorkouts = programWorkouts
    }
    
    private func setImage(selection: PhotosPickerItem?) {
        guard let selection else {
            return
        }
        
        Task {
            if let data = try? await selection.loadTransferable(type: Data.self) {
                if let uiImage = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.programImage = uiImage
                    }
                }
            }
        }
    }
    
    // MARK: Save program
    public func saveProgram(completion: @escaping (_ programImage: UIImage?, _ editedProgram: Program?) -> Void) {
        if programTitle == "" {
            self.didReturnError = true
            self.returnedErrorMessage = "Please enter a title."
            return
        }
        
        if programWorkouts.count == 0 {
            self.didReturnError = true
            self.returnedErrorMessage = "Please add a workout."
            return
        }
        
        // Update program
    }
    
    public func addWorkout(workout: Workout) {
        self.program.workouts.append(workout)
    }
    
    public func editWorkout(workout: Workout) {
        self.program.workouts[workout.id] = workout
    }
    
    public func deleteWorkout(offsets: IndexSet) {
        self.program.workouts.remove(atOffsets: offsets)
    }
}
