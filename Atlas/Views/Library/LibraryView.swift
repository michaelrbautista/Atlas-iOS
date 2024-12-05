//
//  LibraryView.swift
//  Atlas
//
//  Created by Michael Bautista on 11/6/24.
//

import SwiftUI

struct LibraryView: View {
    // MARK: Data
    @EnvironmentObject var userViewModel: UserViewModel
    
    @State var path = [NavigationDestinationTypes]()
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                if let currentUser = UserService.currentUser {
                    // MARK: User
                    Section {
                        NavigationLink(value: NavigationDestinationTypes.ProgramsView(userId: currentUser.id)) {
                            Text("Programs")
                        }
                    } header: {
                        Text("User")
                    }
                    
                    if currentUser.paymentsEnabled {
                        // MARK: Creator
                        Section {
                            NavigationLink(value: NavigationDestinationTypes.CreatorProgramsView(userId: currentUser.id)) {
                                Text("My programs")
                            }
                            
                            NavigationLink(value: NavigationDestinationTypes.CreatorWorkoutsView(userId: currentUser.id)) {
                                Text("My workouts")
                            }
                            
                            NavigationLink(value: NavigationDestinationTypes.CreatorExercisesView(userId: currentUser.id)) {
                                Text("My exercises")
                            }
                        } header: {
                            Text("Creator")
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle("Library")
            .navigationDestination(for: NavigationDestinationTypes.self, destination: { destination in
                switch destination {
                case .UserDetail:
                    let vm = UserDetailViewModel(userId: destination.getId())
                    UserDetailView(viewModel: vm)
                case .UserPrograms:
                    let vm = UserProgramsViewModel(userId: destination.getId())
                    UserProgramsView(viewModel: vm)
                case .ProgramsView:
                    ProgramsView(path: $path)
                case .ProgramDetail:
                    let vm = ProgramDetailViewModel(programId: destination.getId())
                    ProgramDetailView(viewModel: vm, path: $path)
                case .CalendarView:
                    let program = destination.getProgram()
                    CalendarView(
                        programId: program.id,
                        weeks: program.weeks,
                        pages: program.weeks / 4 + 1,
                        remainder: program.weeks % 4
                    )
                case .WorkoutDetail:
                    let vm = WorkoutDetailViewModel(workoutId: destination.getId())
                    WorkoutDetailView(viewModel: vm)
                case .ExerciseDetail:
                    let vm = ExerciseDetailViewModel(programExercise: destination.getProgramExercise())
                    ExerciseDetailView(viewModel: vm)
                case .CreatorProgramsView:
                    CreatorProgramsView(path: $path)
                case .CreatorWorkoutsView:
                    EmptyView()
                case .CreatorExercisesView:
                    EmptyView()
                }
            })
        }
    }
}

#Preview {
    LibraryView()
}
