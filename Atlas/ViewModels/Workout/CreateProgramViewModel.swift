//
//  CreateProgramViewModel.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI
import PhotosUI

final class CreateProgramViewModel: ObservableObject {
    
    // MARK: Variables
    @Published var programImage: UIImage? = nil
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            setImage(selection: imageSelection)
        }
    }
    
    @Published var programTitle: String = ""
    @Published var programDescription: String = ""
    @Published var programWorkouts: [Workout] = [Workout]()
    
    private var exerciseVideos: [ExerciseVideo] = [ExerciseVideo]()
    
    @Published var isSaving = false
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage: String? = nil
    
    // MARK: Initializer
    init() {}
    
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
    public func saveProgram(completion: @escaping (_ savedProgram: SavedProgram?) -> Void) {
        if programImage == nil {
            self.didReturnError = true
            self.returnedErrorMessage = "Please add an image."
            return
        }
        
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
        
        isSaving = true
        
        let createProgramRequest = CreateProgramRequest(
            programImage: programImage ?? UIImage(),
            title: programTitle,
            description: programDescription,
            workouts: programWorkouts
        )
        
        WorkoutService.shared.createProgram(createProgramRequest: createProgramRequest) { savedProgramRef, error in
            if let error = error {
                self.didReturnError = true
                self.returnedErrorMessage = error.localizedDescription
                return
            }
            
            completion(savedProgramRef)
            return
        }
    }
    
    public func addWorkout(workout: Workout) {
        self.programWorkouts.append(workout)
    }
    
    public func editWorkout(workout: Workout) {
        self.programWorkouts[workout.id] = workout
    }
    
    public func deleteWorkout(offsets: IndexSet) {
        self.programWorkouts.remove(atOffsets: offsets)
    }
}
