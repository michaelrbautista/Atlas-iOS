//
//  Navigation.swift
//  Atlas
//
//  Created by Michael Bautista on 9/9/24.
//

import Foundation
import SwiftUI

enum NavigationDestinationTypes: Hashable {
    case UserDetailView(userId: String)
    case UserProgramsView(userId: String)
    case ProgramsView(userId: String)
    case ProgramDetailView(programId: String)
    case WorkoutDetailView(workoutId: String)
    case ExerciseDetailView(programExercise: FetchedProgramExercise)
    case CalendarView(program: Program)
    case CreatorProgramsView(userId: String)
    case CreatorProgramDetailView(programId: String)
    case CreatorWorkoutsView(userId: String)
    case CreatorWorkoutDetailView(workoutId: String)
    case CreatorExercisesView(userId: String)
    
    func getId() -> String {
        switch self {
        case .UserDetailView(let userId):
            return userId
        case .UserProgramsView(let userId):
            return userId
        case .ProgramsView(let userId):
            return userId
        case .ProgramDetailView(let programId):
            return programId
        case .WorkoutDetailView(let workoutId):
            return workoutId
        case .CreatorProgramsView(let userId):
            return userId
        case .CreatorProgramDetailView(let programId):
            return programId
        case .CreatorWorkoutsView(let userId):
            return userId
        case .CreatorWorkoutDetailView(let workoutId):
            return workoutId
        case .CreatorExercisesView(let userId):
            return userId
        default:
            return "nil"
        }
    }
    
    func getProgram() -> Program {
        switch self {
        case .CalendarView(let program):
            return program
        default:
            return Program(id: "", createdAt: "", createdBy: "", title: "", free: true, price: 0, currency: "", weeks: 0, isPrivate: false)
        }
    }
    
    func getProgramExercise() -> FetchedProgramExercise {
        switch self {
        case .ExerciseDetailView(let programExercise):
            return programExercise
        default:
            return FetchedProgramExercise(id: "123", exerciseNumber: 0)
        }
    }
}
