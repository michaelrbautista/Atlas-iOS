//
//  SheetNavigation.swift
//  Atlas
//
//  Created by Michael Bautista on 12/14/24.
//

import SwiftUI

enum SheetNavigationTypes: Hashable {
    case LibraryWorkoutsForProgramView(programId: String, week: Int, day: String)
    case LibraryWorkoutDetailForProgramView(workoutId: String, programId: String, week: Int, day: String)
    case ExerciseDetailForWorkoutView(workoutId: String?, programWorkoutId: String?, exercise: FetchedExercise, exerciseNumber: Int)
    
    func getProgramId() -> String {
        switch self {
        case .LibraryWorkoutsForProgramView(let programId, _, _):
            return programId
        case .LibraryWorkoutDetailForProgramView(_, let programId, _, _):
            return programId
        default:
            return ""
        }
    }
    
    func getProgramWorkoutId() -> String? {
        switch self {
        case .ExerciseDetailForWorkoutView(_, let programWorkoutId, _, _):
            return programWorkoutId
        default:
            return nil
        }
    }
    
    func getWorkoutIdForExercise() -> String? {
        switch self {
        case .ExerciseDetailForWorkoutView(let workoutId, _, _, _):
            return workoutId
        default:
            return nil
        }
    }
    
    func getWorkoutId() -> String {
        switch self {
        case .LibraryWorkoutDetailForProgramView(let workoutId, _, _, _):
            return workoutId
        default:
            return ""
        }
    }
    
    func getExercise() -> FetchedExercise {
        switch self {
        case .ExerciseDetailForWorkoutView(_ , _, let exercise, _):
            return exercise
        default:
            return FetchedExercise(id: "", title: "")
        }
    }
    
    func getExerciseNumber() -> Int {
        switch self {
        case .ExerciseDetailForWorkoutView(_ , _, _, let exerciseNumber):
            return exerciseNumber
        default:
            return 0
        }
    }
    
    func getWeek() -> Int {
        switch self {
        case .LibraryWorkoutsForProgramView(_, let week, _):
            return week
        case .LibraryWorkoutDetailForProgramView(_, _, let week, _):
            return week
        default:
            return 0
        }
    }
    
    func getDay() -> String {
        switch self {
        case .LibraryWorkoutsForProgramView(_, _, let day):
            return day
        case .LibraryWorkoutDetailForProgramView(_, _, _, let day):
            return day
        default:
            return ""
        }
    }
}

struct SheetNavigationViews: ViewModifier {
    
    @Binding var path: [SheetNavigationTypes]
    
    func body(content: Content) -> some View {
        content
            .navigationDestination(for: SheetNavigationTypes.self, destination: { destination in
                switch destination {
                case .LibraryWorkoutsForProgramView:
                    let vm = LibraryWorkoutsForProgramViewModel(programId: destination.getProgramId(), week: destination.getWeek(), day: destination.getDay())
                    LibraryWorkoutsForProgramView(viewModel: vm, path: $path)
                        .toolbarRole(.editor)
                case .LibraryWorkoutDetailForProgramView:
                    let vm = LibraryWorkoutDetailForProgramViewModel(workoutId: destination.getWorkoutId(), programId: destination.getProgramId(), week: destination.getWeek(), day: destination.getDay())
                    LibraryWorkoutDetailForProgramView(viewModel: vm, path: $path)
                case .ExerciseDetailForWorkoutView:
                    let vm = ExerciseDetailForWorkoutViewModel(workoutId: destination.getWorkoutIdForExercise(), programWorkoutId: destination.getProgramWorkoutId(), exercise: destination.getExercise(), exerciseNumber: destination.getExerciseNumber())
                    ExerciseDetailForWorkoutView(viewModel: vm)
                }
            })
    }
}

extension View {
    func sheetNavigationDestination(path: Binding<[SheetNavigationTypes]>) -> some View {
        modifier(SheetNavigationViews(path: path))
    }
}
