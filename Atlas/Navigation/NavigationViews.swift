//
//  NavigationViews.swift
//  Atlas
//
//  Created by Michael Bautista on 12/25/24.
//

import SwiftUI

struct TrainingCoordinatorView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    @StateObject var navigationController: NavigationController = NavigationController()
    
    var body: some View {
        NavigationStack(path: $navigationController.path) {
            navigationController.build(.TrainingView)
                .environmentObject(userViewModel)
                .navigationDestination(for: Screen.self) { screen in
                    navigationController.build(screen)
                }
                .sheet(item: $navigationController.sheet) { sheet in
                    navigationController.build(sheet)
                }
                .fullScreenCover(item: $navigationController.fullScreenCover) { fullScreenCover in
                    navigationController.build(fullScreenCover)
                }
        }
        .environmentObject(navigationController)
    }
}

struct ExploreCoordinatorView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    @StateObject var navigationController: NavigationController = NavigationController()
    
    var body: some View {
        NavigationStack(path: $navigationController.path) {
            navigationController.build(.ExploreView)
                .environmentObject(userViewModel)
                .navigationDestination(for: Screen.self) { screen in
                    navigationController.build(screen)
                }
                .sheet(item: $navigationController.sheet) { sheet in
                    navigationController.build(sheet)
                }
                .fullScreenCover(item: $navigationController.fullScreenCover) { fullScreenCover in
                    navigationController.build(fullScreenCover)
                }
        }
        .environmentObject(navigationController)
    }
}

struct LibraryCoordinatorView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    @StateObject var navigationController: NavigationController = NavigationController()
    
    var body: some View {
        NavigationStack(path: $navigationController.path) {
            navigationController.build(.LibraryView)
                .environmentObject(userViewModel)
                .navigationDestination(for: Screen.self) { screen in
                    navigationController.build(screen)
                }
                .sheet(item: $navigationController.sheet) { sheet in
                    navigationController.build(sheet)
                }
                .fullScreenCover(item: $navigationController.fullScreenCover) { fullScreenCover in
                    navigationController.build(fullScreenCover)
                }
        }
        .environmentObject(navigationController)
    }
}

struct NewProgramWorkoutCoordinatorView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var navigationController: NavigationController
    
    @StateObject var sheetNavigationController: SheetNavigationController = SheetNavigationController()
    
    var programId: String
    var week: Int
    var day: String
    var addWorkoutToProgram: ((ProgramWorkout) -> Void)
    
    var body: some View {
        NavigationStack(path: $sheetNavigationController.path) {
            sheetNavigationController.build(.NewProgramWorkoutView(programId: programId, week: week, day: day, addWorkoutToProgram: addWorkoutToProgram))
                .environmentObject(userViewModel)
                .navigationDestination(for: Screen.self) { screen in
                    sheetNavigationController.build(screen)
                }
        }
        .environmentObject(navigationController)
        .environmentObject(sheetNavigationController)
    }
}

struct AddExerciseToWorkoutCoordinatorView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var navigationController: NavigationController
    
    @StateObject var sheetNavigationController: SheetNavigationController = SheetNavigationController()
    
    var workoutId: String?
    var programWorkoutId: String?
    var exerciseNumber: Int
    var addExerciseToWorkout: ((FetchedWorkoutExercise) -> Void)
    
    var body: some View {
        NavigationStack(path: $sheetNavigationController.path) {
            sheetNavigationController.build(.AddExerciseToWorkoutView(workoutId: workoutId, programWorkoutId: programWorkoutId, exerciseNumber: exerciseNumber, addExerciseToWorkout: addExerciseToWorkout))
                .environmentObject(userViewModel)
                .navigationDestination(for: Screen.self) { screen in
                    sheetNavigationController.build(screen)
                }
        }
        .environmentObject(navigationController)
        .environmentObject(sheetNavigationController)
    }
}
