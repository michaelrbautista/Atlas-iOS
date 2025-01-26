//
//  NavigationTypes.swift
//  Atlas
//
//  Created by Michael Bautista on 1/2/25.
//

import SwiftUI

// MARK: Screen
enum Screen: Identifiable, Hashable {
    // Home
    case TrainingView
    case ExploreView
    case LibraryView
    
    // Library
    case CreatorProgramsView
    case CreatorWorkoutsView
    case CreatorExercisesView
    
    // Subscriptions
    case SubscriptionsView
    
    // Programs
    case ProgramsView
    case ProgramDetailView(programId: String, deleteProgram: (() -> Void)?)
    case CalendarView(program: Program)
    
    // Add workout to program
    case NewProgramWorkoutView(programId: String, week: Int, day: String, addWorkoutToProgram: ((ProgramWorkout) -> Void))
    case LibraryWorkoutsForProgramView(programId: String, week: Int, day: String, addWorkoutToProgram: ((ProgramWorkout) -> Void))
    case LibraryWorkoutDetailForProgramView(workoutId: String, programId: String, week: Int, day: String, addWorkoutToProgram: ((ProgramWorkout) -> Void))
    
    // Workouts
    case LibraryWorkoutDetailView(libraryWorkoutId: String, deleteLibraryWorkout: (() -> Void)?)
    case ProgramWorkoutDetailView(programWorkoutId: String, deleteProgramWorkout: (() -> Void)?)
    
    // Add exercise to workout
    case AddExerciseToWorkoutView(workoutId: String?, programWorkoutId: String?, exerciseNumber: Int, addExerciseToWorkout: ((FetchedWorkoutExercise) -> Void))
    case ExerciseDetailForWorkoutView(workoutId: String?, programWorkoutId: String?, exercise: FetchedExercise, exerciseNumber: Int, addExerciseToWorkout: ((FetchedWorkoutExercise) -> Void))
    
    // Exercises
    case LibraryExerciseDetailView(libraryExercise: FetchedExercise, deleteLibraryExercise: (() -> Void)?)
    case WorkoutExerciseDetailView(workoutExercise: FetchedWorkoutExercise, deleteWorkoutExercise: (() -> Void)?)
    
    // User
    case UserDetailView(userId: String)
    case UserProgramsView(userId: String)
    case UserCollectionsView(userId: String)
    
    // Collection
    case CollectionDetailView(collectionId: String)
    
    // Article
    case ArticleDetailView(article: Article)
    
    var id: Self { return self }
}

extension Screen {
    // Conform to Hashable
    func hash(into hasher: inout Hasher) {
        switch self {
        case .ProgramDetailView:
            hasher.combine("ProgramDetailView")
        case .ProgramWorkoutDetailView:
            hasher.combine("ProgramWorkoutDetailView")
        case .LibraryWorkoutDetailView:
            hasher.combine("LibraryWorkoutDetailView")
        case .WorkoutExerciseDetailView:
            hasher.combine("WorkoutExerciseDetailView")
        case .LibraryExerciseDetailView:
            hasher.combine("LibraryExerciseDetailView")
        case .NewProgramWorkoutView:
            hasher.combine("NewProgramWorkoutView")
        case .LibraryWorkoutsForProgramView:
            hasher.combine("LibraryWorkoutsForProgramView")
        case .AddExerciseToWorkoutView:
            hasher.combine("AddExerciseToWorkoutView")
        case .LibraryWorkoutDetailForProgramView:
            hasher.combine("LibraryWorkoutDetailForProgramView")
        default:
            break
        }
    }
    
    // Conform to Equatable
    static func == (lhs: Screen, rhs: Screen) -> Bool {
        switch (lhs, rhs) {
        case (.ProgramDetailView, .ProgramDetailView):
            return true
        case (.ProgramWorkoutDetailView, .ProgramWorkoutDetailView):
            return true
        case (.LibraryWorkoutDetailView, .LibraryWorkoutDetailView):
            return true
        case (.WorkoutExerciseDetailView, .WorkoutExerciseDetailView):
            return true
        case (.LibraryExerciseDetailView, .LibraryExerciseDetailView):
            return true
        case (.LibraryWorkoutsForProgramView, .LibraryWorkoutsForProgramView):
            return true
        case (.LibraryWorkoutDetailForProgramView, .LibraryWorkoutDetailForProgramView):
            return true
        default:
            return true
        }
    }
}

// MARK: Sheet
enum Sheet: Identifiable, Hashable {
    // New
    case NewProgramView(addProgram: ((Program) -> Void))
    case NewLibraryWorkoutView(addLibraryWorkout: ((FetchedWorkout) -> Void))
    
    // For navigation within sheet
    case NewProgramWorkoutCoordinatorView(programId: String, week: Int, day: String, addProgramWorkout: ((ProgramWorkout) -> Void))
    case AddExerciseToWorkoutCoordinatorView(workoutId: String?, programWorkoutId: String?, exerciseNumber: Int, addExerciseToWorkout: ((FetchedWorkoutExercise) -> Void))
    
    case NewLibraryExerciseView(addLibraryExercise: ((FetchedExercise) -> Void))
    case NewWorkoutExerciseView(workoutId: String?, programWorkoutId: String?, exerciseNumber: Int, addExerciseToWorkout: ((FetchedWorkoutExercise) -> Void))
    
    // Edit
    case EditProgramView(program: Program, programImage: UIImage?, editProgram: ((Program) -> Void)?)
    case EditLibraryWorkoutView(libraryWorkout: FetchedWorkout, editLibraryWorkout: ((FetchedWorkout) -> Void))
    case EditProgramWorkoutView(programWorkout: ProgramWorkout, editProgramWorkout: ((ProgramWorkout) -> Void))
    case EditLibraryExerciseView(libraryExercise: FetchedExercise, exerciseVideo: Data?, editLibraryExercise: ((FetchedExercise) -> Void))
    case EditWorkoutExerciseView(workoutExercise: FetchedWorkoutExercise, editWorkoutExercise: ((FetchedWorkoutExercise) -> Void))
    
    case SubscribeSheet
    
    var id: Self { return self }
}

extension Sheet {
    // Conform to Hashable
    func hash(into hasher: inout Hasher) {
        switch self {
        // New
        case .NewProgramView:
            hasher.combine("NewProgramView")
        case .NewLibraryWorkoutView:
            hasher.combine("NewLibraryWorkoutView")
        case .NewProgramWorkoutCoordinatorView:
            hasher.combine("NewProgramWorkoutCoordinatorView")
        case .AddExerciseToWorkoutCoordinatorView:
            hasher.combine("AddExerciseToWorkoutCoordinatorView")
        case .NewLibraryExerciseView:
            hasher.combine("NewLibraryExerciseView")
        case .NewWorkoutExerciseView:
            hasher.combine("NewWorkoutExerciseView")
            
        // Edit
        case .EditProgramView:
            hasher.combine("EditProgramView")
        case .EditLibraryWorkoutView:
            hasher.combine("EditLibraryWorkoutView")
        case .EditProgramWorkoutView:
            hasher.combine("EditProgramWorkoutView")
        case .EditLibraryExerciseView:
            hasher.combine("EditLibraryExerciseView")
        case .EditWorkoutExerciseView:
            hasher.combine("EditWorkoutExerciseView")
            
        case .SubscribeSheet:
            hasher.combine("SubscribeSheet")
        }
    }
    
    // Conform to Equatable
    static func == (lhs: Sheet, rhs: Sheet) -> Bool {
        switch (lhs, rhs) {
        default:
            return true
        }
    }
}

// MARK: Full screen cover
enum FullScreenCover: Identifiable, Hashable {
    case ViewVideo
    
    var id: Self { return self }
}
