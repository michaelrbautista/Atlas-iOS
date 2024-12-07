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
                                Text("My Programs")
                            }
                            
                            NavigationLink(value: NavigationDestinationTypes.CreatorWorkoutsView(userId: currentUser.id)) {
                                Text("My Workouts")
                            }
                            
                            NavigationLink(value: NavigationDestinationTypes.CreatorExercisesView(userId: currentUser.id)) {
                                Text("My Exercises")
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
                case .UserDetailView:
                    let vm = UserDetailViewModel(userId: destination.getId())
                    UserDetailView(viewModel: vm)
                case .UserProgramsView:
                    let vm = UserProgramsViewModel(userId: destination.getId())
                    UserProgramsView(viewModel: vm)
                case .ProgramsView:
                    ProgramsView(path: $path)
                case .ProgramDetailView:
                    let vm = ProgramDetailViewModel(programId: destination.getId())
                    ProgramDetailView(viewModel: vm, path: $path)
                case .CalendarView:
                    let program = destination.getProgram()
                    CalendarView(
                        programId: program.id,
                        isCreator: UserService.currentUser?.id == program.createdBy,
                        weeks: program.weeks,
                        pages: program.weeks / 4 + 1,
                        remainder: program.weeks % 4
                    )
                case .WorkoutDetailView:
                    let vm = WorkoutDetailViewModel(workoutId: destination.getId())
                    WorkoutDetailView(viewModel: vm)
                case .ExerciseDetailView:
                    let vm = ExerciseDetailViewModel(programExercise: destination.getProgramExercise())
                    ExerciseDetailView(viewModel: vm)
                case .CreatorProgramsView:
                    CreatorProgramsView(path: $path)
                case .CreatorProgramDetailView:
                    let vm = CreatorProgramDetailViewModel(programId: destination.getId())
                    CreatorProgramDetailView(viewModel: vm, path: $path)
                case .CreatorWorkoutsView:
                    CreatorWorkoutsView(path: $path)
                case .CreatorWorkoutDetailView:
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
