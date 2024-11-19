//
//  Navigation.swift
//  Atlas
//
//  Created by Michael Bautista on 9/9/24.
//

import Foundation
import SwiftUI

enum NavigationDestinationTypes: Hashable {
    case UserDetail(userId: String)
    case UserPrograms(userId: String)
    case PostsView(userId: String)
    case PostDetail(post: Post)
    case ProgramsView(userId: String)
    case ProgramDetail(programId: String)
    case WorkoutDetail(workoutId: String)
    case ExerciseDetail(workoutExercise: WorkoutExercise)
    case CalendarView(program: Program)
    
    func getId() -> String {
        switch self {
        case .UserDetail(let userId):
            return userId
        case .PostsView(let userId):
            return userId
        case .UserPrograms(let userId):
            return userId
        case .ProgramsView(let userId):
            return userId
        case .ProgramDetail(let programId):
            return programId
        case .WorkoutDetail(let workoutId):
            return workoutId
        default:
            return "nil"
        }
    }
    
    func getPost() -> Post {
        switch self {
        case .PostDetail(let post):
            return post
        default:
            return Post(id: "", createdAt: "", createdBy: "")
        }
    }
    
    func getProgram() -> Program {
        switch self {
        case .CalendarView(let program):
            return program
        default:
            return Program(id: "", createdAt: "", createdBy: "", title: "", free: true, price: 0, currency: "", weeks: 0)
        }
    }
    
    func getWorkoutExercise() -> WorkoutExercise {
        switch self {
        case .ExerciseDetail(let workoutExercise):
            return workoutExercise
        default:
            return WorkoutExercise(id: "", createdAt: "", createdBy: "", workoutId: "", exerciseId: "", exerciseNumber: 1, title: "", sets: 1, reps: 1)
        }
    }
}
