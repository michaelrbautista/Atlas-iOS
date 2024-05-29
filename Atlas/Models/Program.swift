//
//  Workout.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

//import SwiftUI
import Firebase
import SwiftUI
import PhotosUI

// MARK: Program
struct Program: Codable, Identifiable, Hashable {
    // id is Firebase documentId
    var id: String
    
    var title: String
    var description: String?
    var imageUrl: String = ""
    var imagePath: String = ""
    var uid: String
    var dateSaved: Date
    
    var workouts: [Workout] = [Workout]()
}

// MARK: Workout
struct Workout: Codable, Identifiable, Hashable {
    // id is used to keep track of workout number
    var id: Int
    
    var title: String
    var description: String?
    var exercises: [Exercise] = [Exercise]()
}

// MARK: Exercise
struct Exercise: Codable, Identifiable, Hashable {
    // id used to keep track of exercise number
    var id: Int
    
    var title: String
    var sets: String
    var reps: String
    var instructions: String?
    
    var videoUrl: String?
}

// MARK: Exercise video
struct ExerciseVideo {
    var video: PhotosPickerItem
    var exerciseNumber: Int
    var workoutNumber: Int
}

// MARK: Saved program - reference to program that was saved by a user
struct SavedProgram: Codable, Identifiable, Hashable {
    // id is documentId
    var id: String
    
    // User that saved the program
    var uid: String
    
    var creatorId: String
    var teamId: String?
    var programId: String
    var dateSaved: Date
    
    // Reference variables - these will change when edited
    var imageUrl: String
    var title: String
    var username: String
}

// MARK: Requests
struct AddExerciseVideoRequest {
    let programId: String
    let workoutNumber: String
    let exerciseNumber: String
}

struct GetProgramsRequest {
    let uid: String
    let lastProgramRef: QueryDocumentSnapshot?
}

struct GetTeamProgramsRequest {
    let teamId: String
    let lastProgramRef: QueryDocumentSnapshot?
}

struct CreateProgramRequest {
    var programImage: UIImage?
    var title: String
    var description: String
    var teamId: String?
    var workouts: [Workout]
}
