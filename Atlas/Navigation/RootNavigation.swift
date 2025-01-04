//
//  Navigation.swift
//  Atlas
//
//  Created by Michael Bautista on 9/9/24.
//

import Foundation
import SwiftUI

enum RootNavigationTypes: Hashable {
    // Home
    case TrainingView
    case ExploreView
    case LibraryView
    
    // Program
    case ProgramsView(userId: String)
    case ProgramDetailView(programId: String)
    case CalendarView(program: Program)
    
    // Workout
    case ProgramWorkoutDetailView(workoutId: String)
    case LibraryWorkoutDetailView(workoutId: String)
    
    // Exercise
    case ProgramExerciseDetailView(workoutExercise: FetchedWorkoutExercise)
    case LibraryExerciseDetailView(exercise: FetchedExercise)
    
    // Library
    case CreatorProgramsView(userId: String)
    case CreatorWorkoutsView(userId: String)
    case CreatorExercisesView(userId: String)
    
    // User
    case UserDetailView(userId: String)
    case UserProgramsView(userId: String)
    
    func getId() -> String {
        switch self {
        // Program
        case .ProgramsView(let userId):
            return userId
        case .ProgramDetailView(let programId):
            return programId
        
        // Workout
        case .ProgramWorkoutDetailView(let programWorkoutId):
            return programWorkoutId
        case .LibraryWorkoutDetailView(let workoutId):
            return workoutId
        
        // Library
        case .CreatorProgramsView(let userId):
            return userId
        case .CreatorWorkoutsView(let userId):
            return userId
        case .CreatorExercisesView(let userId):
            return userId
        
        // User
        case .UserDetailView(let userId):
            return userId
        case .UserProgramsView(let userId):
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
            return Program(id: "", title: "", price: 0, weeks: 0, free: false, isPrivate: false)
        }
    }
    
    func getWorkoutExercise() -> FetchedWorkoutExercise {
        switch self {
        case .ProgramExerciseDetailView(let workoutExercise):
            return workoutExercise
        default:
            return FetchedWorkoutExercise(id: "", createdBy: "", exerciseId: "", exerciseNumber: 1)
        }
    }
    
    func getLibraryExercise() -> FetchedExercise {
        switch self {
        case .LibraryExerciseDetailView(let libraryExercise):
            return libraryExercise
        default:
            return FetchedExercise(id: "", createdBy: "", title: "")
        }
    }
}

struct RootNavigationViews: ViewModifier {
    
    @Binding var path: [RootNavigationTypes]
    
    func body(content: Content) -> some View {
        content
            .navigationDestination(for: RootNavigationTypes.self, destination: { destination in
                switch destination {
                // Program
                case .ProgramsView:
                    ProgramsView()
                case .ProgramDetailView:
                    let vm = ProgramDetailViewModel(programId: destination.getId())
                    ProgramDetailView(viewModel: vm)
                case .CalendarView:
                    let program = destination.getProgram()
                    CalendarView(
                        programId: program.id,
                        isCreator: UserService.currentUser?.id == program.createdBy?.id,
                        weeks: program.weeks,
                        pages: program.weeks / 4 + 1,
                        remainder: program.weeks % 4
                    )
                    
                // Workout
                case .ProgramWorkoutDetailView:
                    let vm = ProgramWorkoutDetailViewModel(programWorkoutId: destination.getId())
                    ProgramWorkoutDetailView(viewModel: vm)
                case .LibraryWorkoutDetailView:
                    let vm = LibraryWorkoutDetailViewModel(libraryWorkoutId: destination.getId())
                    LibraryWorkoutDetailView(viewModel: vm)
                    
                // Exercise
                case .LibraryExerciseDetailView:
                    let vm = LibraryExerciseDetailViewModel(exercise: destination.getLibraryExercise())
                    LibraryExerciseDetailView(viewModel: vm)
                case .ProgramExerciseDetailView:
                    let vm = WorkoutExerciseDetailViewModel(workoutExercise: destination.getWorkoutExercise())
                    WorkoutExerciseDetailView(viewModel: vm)
                    
                // Library
                case .CreatorProgramsView:
                    CreatorProgramsView()
                case .CreatorWorkoutsView:
                    CreatorWorkoutsView()
                case .CreatorExercisesView:
                    CreatorExercisesView()
                    
                // User
                case .UserDetailView:
                    let vm = UserDetailViewModel(userId: destination.getId())
                    UserDetailView(viewModel: vm)
                case .UserProgramsView:
                    let vm = UserProgramsViewModel(userId: destination.getId())
                    UserProgramsView(viewModel: vm)
                    
                default:
                    EmptyView()
                }
            })
    }
}

extension View {
    func rootNavigationDestination(path: Binding<[RootNavigationTypes]>) -> some View {
        modifier(RootNavigationViews(path: path))
    }
}
