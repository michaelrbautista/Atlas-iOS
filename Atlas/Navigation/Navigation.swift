//
//  Navigation.swift
//  Atlas
//
//  Created by Michael Bautista on 12/24/24.
//

import SwiftUI

// MARK: Navigation controller
protocol CoordinatorProtocol: ObservableObject {
    var path: NavigationPath { get set }
    var sheet: Sheet? { get set }
    var fullScreenCover: FullScreenCover? { get set }

    func push(_ screen:  Screen)
    func pop()
    func popToRoot()
    func presentSheet(_ sheet: Sheet)
    func dismissSheet()
    func presentFullScreenCover(_ fullScreenCover: FullScreenCover)
    func dismissFullScreenCover()
}

class NavigationController: CoordinatorProtocol {
    @Published var path: NavigationPath = NavigationPath()
    @Published var sheet: Sheet? = nil
    @Published var fullScreenCover: FullScreenCover? = nil
    
    func push(_ screen: Screen) {
        path.append(screen)
    }
    
    func presentSheet(_ sheet: Sheet) {
        self.sheet = sheet
    }
    
    func presentFullScreenCover(_ fullScreenCover: FullScreenCover) {
        self.fullScreenCover = fullScreenCover
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func dismissSheet() {
        self.sheet = nil
    }
    
    func dismissFullScreenCover() {
        self.fullScreenCover = nil
    }
    
    // MARK: - Screen views
    @ViewBuilder
    func build(_ screen: Screen) -> some View {
        switch screen {
        // Home
        case .TrainingView:
            TrainingView()
        case .ExploreView:
            ExploreView()
        case .LibraryView:
            LibraryView()
            
        // Library
        case .CreatorProgramsView:
            CreatorProgramsView()
        case .CreatorWorkoutsView:
            CreatorWorkoutsView()
        case .CreatorExercisesView:
            CreatorExercisesView()
            
        // Subscriptions
        case .SubscriptionsView:
            SubscriptionsView()
            
        // Programs
        case .ProgramsView:
            ProgramsView()
        case .ProgramDetailView(let programId, let deleteProgram):
            ProgramDetailView(viewModel: ProgramDetailViewModel(programId: programId), deleteProgram: deleteProgram)
        case .CalendarView(let program):
            CalendarView(
                programId: program.id,
                isCreator: UserService.currentUser?.id == program.createdBy?.id,
                weeks: program.weeks,
                pages: program.weeks / 4 + 1,
                remainder: program.weeks % 4
            )
            
        // Add workout to program
        case .LibraryWorkoutsForProgramView(let programId, let week, let day, let addWorkoutToProgram):
            let vm = LibraryWorkoutsForProgramViewModel(programId: programId, week: week, day: day
            )
            LibraryWorkoutsForProgramView(viewModel: vm, addWorkoutToProgram: addWorkoutToProgram)
        case .LibraryWorkoutDetailForProgramView(let workoutId, let programId, let week, let day, let addWorkoutToProgram):
            let vm = LibraryWorkoutDetailForProgramViewModel(workoutId: workoutId, programId: programId, week: week, day: day)
            LibraryWorkoutDetailForProgramView(viewModel: vm, addWorkoutToProgram: addWorkoutToProgram)
            
        // Workouts
        case .NewProgramWorkoutView(let programId, let week, let day, let addWorkoutToProgram):
            let vm = NewProgramWorkoutViewModel(programId: programId, week: week, day: day)
            NewProgramWorkoutView(viewModel: vm, addWorkoutToProgram: addWorkoutToProgram)
        case .LibraryWorkoutDetailView(let libraryWorkoutId, let deleteLibraryWorkout):
            let vm = LibraryWorkoutDetailViewModel(libraryWorkoutId: libraryWorkoutId)
            LibraryWorkoutDetailView(viewModel: vm, deleteLibraryWorkout: deleteLibraryWorkout)
        case .ProgramWorkoutDetailView(let programWorkoutId, let deleteProgramWorkout):
            let vm = ProgramWorkoutDetailViewModel(programWorkoutId: programWorkoutId)
            ProgramWorkoutDetailView(viewModel: vm, deleteProgramWorkout: deleteProgramWorkout)
            
        // Add exercise to workout
        case .AddExerciseToWorkoutView(let workoutId, let programWorkoutId, let exerciseNumber, let addExerciseToWorkout):
            let vm = AddExerciseToWorkoutViewModel(workoutId: workoutId, programWorkoutId: programWorkoutId, exerciseNumber: exerciseNumber)
            AddExerciseToWorkoutView(viewModel: vm, addExerciseToWorkout: addExerciseToWorkout)
            
        // Exercises
        case .LibraryExerciseDetailView(let libraryExercise, let deleteLibraryExercise):
            let vm = LibraryExerciseDetailViewModel(exercise: libraryExercise)
            LibraryExerciseDetailView(viewModel: vm, deleteLibraryExercise: deleteLibraryExercise)
        case .WorkoutExerciseDetailView(let workoutExercise, let deleteWorkoutExercise):
            let vm = WorkoutExerciseDetailViewModel(workoutExercise: workoutExercise)
            WorkoutExerciseDetailView(viewModel: vm, deleteWorkoutExercise: deleteWorkoutExercise)
            
        // User
        case .UserDetailView(let userId):
            let vm = UserDetailViewModel(userId: userId)
            UserDetailView(viewModel: vm)
        case .UserProgramsView(let userId):
            let vm = UserProgramsViewModel(userId: userId)
            UserProgramsView(viewModel: vm)
        case .UserCollectionsView(let userId):
            let vm = UserCollectionsViewModel(userId: userId)
            UserCollectionsView(viewModel: vm)
            
        // Collection
        case .CollectionDetailView(let collectionId):
            let vm = CollectionDetailViewModel(collectionId: collectionId)
            CollectionDetailView(viewModel: vm)
            
        // Article
        case .ArticleDetailView(let article):
            let vm = ArticleDetailViewModel(article: article)
            ArticleDetailView(viewModel: vm)
            
        default:
            Text("Couldn't load page.")
        }
    }
    
    // MARK: Sheet views
    @ViewBuilder
    func build(_ sheet: Sheet) -> some View {
        switch sheet {
        // New
        case .NewProgramView(let addProgram):
            NewProgramView(addProgram: addProgram)
        case .NewLibraryWorkoutView(let addWorkout):
            NewLibraryWorkoutView(addWorkout: addWorkout)
        
        // For navigation within sheet
        case .NewProgramWorkoutCoordinatorView(let programId, let week, let day, let addWorkoutToProgram):
            NewProgramWorkoutCoordinatorView(programId: programId, week: week, day: day, addWorkoutToProgram: addWorkoutToProgram)
        case .AddExerciseToWorkoutCoordinatorView(let workoutId, let programWorkoutId, let exerciseNumber, let addExerciseToWorkout):
            AddExerciseToWorkoutCoordinatorView(workoutId: workoutId, programWorkoutId: programWorkoutId, exerciseNumber: exerciseNumber, addExerciseToWorkout: addExerciseToWorkout)
        
        case .NewLibraryExerciseView(let addLibraryExercise):
            NewLibraryExerciseView(addExercise: addLibraryExercise)
        case .NewWorkoutExerciseView(let workoutId, let programWorkoutId, let exerciseNumber, let addExerciseToWorkout):
            let vm = AddExerciseToWorkoutViewModel(workoutId: workoutId, programWorkoutId: programWorkoutId, exerciseNumber: exerciseNumber)
            AddExerciseToWorkoutView(viewModel: vm, addExerciseToWorkout: addExerciseToWorkout)
            
        // Edit
        case .EditProgramView(let program, let programImage, let editProgram):
            let vm = EditProgramViewModel(program: program, programImage: programImage)
            EditProgramView(viewModel: vm, editProgram: editProgram)
            
        case .EditLibraryWorkoutView(let libraryWorkout, let editLibraryWorkout):
            let vm = EditLibraryWorkoutViewModel(workout: libraryWorkout)
            EditLibraryWorkoutView(viewModel: vm, editLibraryWorout: editLibraryWorkout)
        case .EditProgramWorkoutView(let programWorkout, let editProgramWorkout):
            let vm = EditProgramWorkoutViewModel(workout: programWorkout)
            EditProgramWorkoutView(viewModel: vm, editProgramWorout: editProgramWorkout)
            
        case .EditLibraryExerciseView(let libraryExercise, let exerciseVideo, let editLibraryExercise):
            let vm = EditLibraryExerciseViewModel(exercise: libraryExercise, exerciseVideo: exerciseVideo)
            EditLibraryExerciseView(viewModel: vm, editLibraryExercise: editLibraryExercise)
        case .EditWorkoutExerciseView(let workoutExercise, let editWorkoutExercise):
            let vm = EditWorkoutExerciseViewModel(exercise: workoutExercise)
            EditWorkoutExerciseView(viewModel: vm, editWorkoutExercise: editWorkoutExercise)
            
        case .SubscribeSheet:
            SubscribeSheet()
                .presentationDetents(
                    [.medium]
                 )
        }
    }
    
    @ViewBuilder
    func build(_ fullScreenCover: FullScreenCover) -> some View {
        switch fullScreenCover {
        case .ViewVideo:
            Text("View video")
        }
    }
}

// MARK: Sheet navigation controller
protocol SheetCoordinatorProtocol: ObservableObject {
    var path: NavigationPath { get set }
    var fullScreenCover: FullScreenCover? { get set }

    func push(_ screen:  Screen)
    func pop()
    func popToRoot()
    func presentFullScreenCover(_ fullScreenCover: FullScreenCover)
    func dismissFullScreenCover()
}

class SheetNavigationController: SheetCoordinatorProtocol {
    @Published var path: NavigationPath = NavigationPath()
    @Published var fullScreenCover: FullScreenCover? = nil
    
    func push(_ screen: Screen) {
        path.append(screen)
    }
    
    func presentFullScreenCover(_ fullScreenCover: FullScreenCover) {
        self.fullScreenCover = fullScreenCover
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func dismissFullScreenCover() {
        self.fullScreenCover = nil
    }
    
    // MARK: - Screen views
    @ViewBuilder
    func build(_ screen: Screen) -> some View {
        switch screen {
        // Add workout to program
        case .NewProgramWorkoutView(let programId, let week, let day, let addWorkoutToProgram):
            let vm = NewProgramWorkoutViewModel(programId: programId, week: week, day: day)
            NewProgramWorkoutView(viewModel: vm, addWorkoutToProgram: addWorkoutToProgram)
        case .LibraryWorkoutsForProgramView(let programId, let week, let day, let addWorkoutToProgram):
            let vm = LibraryWorkoutsForProgramViewModel(programId: programId, week: week, day: day
            )
            LibraryWorkoutsForProgramView(viewModel: vm, addWorkoutToProgram: addWorkoutToProgram)
        case .LibraryWorkoutDetailForProgramView(let workoutId, let programId, let week, let day, let addWorkoutToProgram):
            let vm = LibraryWorkoutDetailForProgramViewModel(workoutId: workoutId, programId: programId, week: week, day: day)
            LibraryWorkoutDetailForProgramView(viewModel: vm, addWorkoutToProgram: addWorkoutToProgram)
            
        // Add exercise to workout
        case .AddExerciseToWorkoutView(let workoutId, let programWorkoutId, let exerciseNumber, let addExerciseToWorkout):
            let vm = AddExerciseToWorkoutViewModel(workoutId: workoutId, programWorkoutId: programWorkoutId, exerciseNumber: exerciseNumber)
            AddExerciseToWorkoutView(viewModel: vm, addExerciseToWorkout: addExerciseToWorkout)
        case .ExerciseDetailForWorkoutView(let workoutId, let programWorkoutId, let exercise, let exerciseNumber, let addExerciseToWorkout):
            let vm = ExerciseDetailForWorkoutViewModel(workoutId: workoutId, programWorkoutId: programWorkoutId, exercise: exercise, exerciseNumber: exerciseNumber)
            ExerciseDetailForWorkoutView(viewModel: vm, addExerciseToWorkout: addExerciseToWorkout)
        default:
            Text("Couldn't load page.")
        }
    }
    
    @ViewBuilder
    func build(_ fullScreenCover: FullScreenCover) -> some View {
        switch fullScreenCover {
        case .ViewVideo:
            Text("View video")
        }
    }
}
