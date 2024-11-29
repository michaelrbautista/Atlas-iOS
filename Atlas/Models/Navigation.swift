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
    case ProgramsView(userId: String)
    case ProgramDetail(programId: String)
    case WorkoutDetail(workoutId: String)
    case ExerciseDetail(programExercise: FetchedProgramExercise)
    case CalendarView(program: Program)
    
    func getId() -> String {
        switch self {
        case .UserDetail(let userId):
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
    
    func getProgram() -> Program {
        switch self {
        case .CalendarView(let program):
            return program
        default:
            return Program(id: "", createdAt: "", createdBy: "", title: "", free: true, price: 0, currency: "", weeks: 0)
        }
    }
    
    func getProgramExercise() -> FetchedProgramExercise {
        switch self {
        case .ExerciseDetail(let programExercise):
            return programExercise
        default:
            return FetchedProgramExercise(id: "123", exerciseId: "123", exerciseNumber: 0)
        }
    }
}
