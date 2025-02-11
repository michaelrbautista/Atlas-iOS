//
//  Navigation.swift
//  Atlas
//
//  Created by Michael Bautista on 2/11/25.
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
            
        // Subscriptions
        case .SubscriptionsView:
            SubscriptionsView()
            
        // Programs
        case .ProgramsView:
            ProgramsView()
        case .ProgramDetailView(let programId, let removeProgram):
            ProgramDetailView(viewModel: ProgramDetailViewModel(programId: programId), removeProgram: removeProgram)
        case .CalendarView(let program):
            CalendarView(
                programId: program.id,
                isCreator: UserService.currentUser?.id == program.createdBy?.id,
                weeks: program.weeks,
                pages: program.weeks / 4 + 1,
                remainder: program.weeks % 4
            )
            
        // Workouts
        case .ProgramWorkoutDetailView(let programWorkoutId):
            let vm = ProgramWorkoutDetailViewModel(programWorkoutId: programWorkoutId)
            ProgramWorkoutDetailView(viewModel: vm)
            
        // Exercises
        case .WorkoutExerciseDetailView(let workoutExercise):
            let vm = WorkoutExerciseDetailViewModel(workoutExercise: workoutExercise)
            WorkoutExerciseDetailView(viewModel: vm)
            
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
