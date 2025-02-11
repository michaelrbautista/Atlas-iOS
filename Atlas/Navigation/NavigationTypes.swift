//
//  NavigationTypes.swift
//  Atlas
//
//  Created by Michael Bautista on 2/11/25.
//

import SwiftUI

// MARK: Screen
enum Screen: Identifiable, Hashable {
    // Home
    case TrainingView
    case ExploreView
    case LibraryView
    
    // Subscriptions
    case SubscriptionsView
    
    // Programs
    case ProgramsView
    case ProgramDetailView(programId: String, removeProgram: (() -> Void)?)
    case CalendarView(program: Program)
    
    // Workouts
    case LibraryWorkoutDetailView(libraryWorkoutId: String)
    case ProgramWorkoutDetailView(programWorkoutId: String)
    
    // Exercises
    case WorkoutExerciseDetailView(workoutExercise: FetchedWorkoutExercise)
    
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
        default:
            return true
        }
    }
}

// MARK: Sheet
enum Sheet: Identifiable, Hashable {
    case SubscribeSheet
    
    var id: Self { return self }
}

extension Sheet {
    // Conform to Hashable
    func hash(into hasher: inout Hasher) {
        switch self {
        // New
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
