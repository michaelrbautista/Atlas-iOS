//
//  TrainingView.swift
//  Atlas
//
//  Created by Michael Bautista on 11/6/24.
//

import SwiftUI

struct TrainingView: View {
    // MARK: UI State
    @State var presentSettings = false
    @State var presentCreateNutritionPlan = false
    @State var presentAddWorkout = false
    
    // MARK: Data
    @StateObject private var viewModel = TrainingViewModel()
    
    @State var path = [NavigationDestinationTypes]()
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                // MARK: Workouts
                Section {
                    if viewModel.startedProgram != nil && viewModel.workouts != nil && !viewModel.isLoading {
                        if viewModel.workouts!.count == 0 {
                            Text("No workouts today.")
                                .foregroundStyle(Color.ColorSystem.systemGray)
                        } else {
                            ForEach(viewModel.workouts!) { workout in
                                ZStack {
                                    WorkoutCell(
                                        title: workout.title,
                                        description: workout.description ?? ""
                                    )
                                    .background(Color.ColorSystem.systemGray6)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    
                                    NavigationLink(value: NavigationDestinationTypes.WorkoutDetail(workoutId: workout.id)) {
                                        
                                    }
                                    .opacity(0)
                                }
                                .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 16, trailing: 20))
                                .listRowSeparator(.hidden)
                            }
                        }
                    } else {
                        if !viewModel.isLoading {
                            HStack {
                                Text("You haven't started a program yet.")
                                    .font(Font.FontStyles.headline)
                                    .foregroundStyle(Color.ColorSystem.systemGray)
                                    .padding(10)
                                
                                Spacer()
                            }
                            .background(Color.ColorSystem.systemGray6)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
                            .listRowSeparator(.hidden)
                        }
                    }
                } header: {
                    Text("Training")
                        .font(Font.FontStyles.title3)
                        .foregroundStyle(Color.ColorSystem.primaryText)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                }
            }
            .listStyle(.plain)
            .listRowSeparator(.hidden)
            .scrollContentBackground(.hidden)
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle(Date.now.formatted(date: .abbreviated, time: .omitted))
            .background(Color.ColorSystem.systemBackground)
            .refreshable(action: {
                viewModel.refreshHome()
            })
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button("", systemImage: "person.circle.fill") {
                        presentSettings.toggle()
                    }
                    .tint(Color.ColorSystem.primaryText)
                }
            })
            .sheet(isPresented: $presentSettings, content: {
                if let currentUser = UserService.currentUser {
                    SettingsView(user: currentUser)
                } else {
                    Text("Couldn't get current user.")
                }
            })
            .alert(isPresented: $viewModel.didReturnError, content: {
                Alert(title: Text(viewModel.returnedErrorMessage))
            })
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
                    EmptyView()
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
    TrainingView()
        .environmentObject(UserViewModel())
}
