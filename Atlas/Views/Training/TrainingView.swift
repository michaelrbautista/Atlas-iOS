//
//  TrainingView.swift
//  Atlas
//
//  Created by Michael Bautista on 11/6/24.
//

import SwiftUI
import HealthKit

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
                    if viewModel.startedProgram != nil && viewModel.workouts != nil {
                        if viewModel.workouts!.count == 0 {
                            Text("No workouts")
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
                } header: {
                    Text("Training")
                        .font(Font.FontStyles.title3)
                        .foregroundStyle(Color.ColorSystem.primaryText)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                }
                
//                #if DEBUG
//                Button {
//                    let domain = Bundle.main.bundleIdentifier!
//                    UserDefaults.standard.removePersistentDomain(forName: domain)
//                    UserDefaults.standard.synchronize()
//                } label: {
//                    Text("Reset User Defaults")
//                }
//                #endif
                
                // MARK: Nutrition
//                Section {
//                    if viewModel.nutritionPlan != nil {
//                        CalorieExpenditureCell(activity: "Basal metabolic rate", calories: viewModel.nutritionPlan!.bmr)
//                            .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
//                            .listRowSeparator(.hidden)
//                        
//                        CalorieExpenditureCell(activity: "Basic activity", calories: viewModel.basicActivity)
//                            .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
//                            .listRowSeparator(.hidden)
//                        
//                        ForEach(Array(viewModel.nutritionWorkouts.enumerated()), id: \.offset) { index, workout in
//                            HKWorkoutCell(workout: workout)
//                                .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
//                                .listRowSeparator(.hidden)
//                        }
//                        
//                        CalorieExpenditureCell(activity: "Total estimate", calories: viewModel.totalCalories)
//                            .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
//                            .listRowSeparator(.hidden)
//                        
//                        // Additional exercise
//                        VStack {
//                            Button {
//                                if viewModel.hasAuthorizedHealthData {
//                                    self.presentAddWorkout.toggle()
//                                } else {
//                                    Task {
//                                        await viewModel.requestPermission()
//                                    }
//                                }
//                            } label: {
//                                HStack {
//                                    Spacer()
//                                    
//                                    if viewModel.hasAuthorizedHealthData {
//                                        Text("Import workout from Apple Health")
//                                    } else {
//                                        Text("Authorize access to HealthKit")
//                                    }
//                                    
//                                    Spacer()
//                                }
//                                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
//                                .background(Color.ColorSystem.systemGray5)
//                                .clipShape(RoundedRectangle(cornerRadius: 10))
//                            }
//                            .buttonStyle(.plain)
//                        }
//                        .listRowSeparator(.hidden)
//                        .sheet(isPresented: $presentAddWorkout, content: {
//                            AddWorkoutView { workout in
//                                viewModel.addWorkoutCaloriesToTotal(workout: workout)
//                            }
//                        })
//                    } else {
//                        Button {
//                            presentCreateNutritionPlan.toggle()
//                        } label: {
//                            HStack {
//                                Spacer()
//                                
//                                Text("Create nutrition plan")
//                                    .font(Font.FontStyles.headline)
//                                    .foregroundStyle(Color.ColorSystem.primaryText)
//                                
//                                Spacer()
//                            }
//                            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
//                            .background(Color.ColorSystem.systemGray5)
//                            .clipShape(RoundedRectangle(cornerRadius: 10))
//                        }
//                        .sheet(isPresented: $presentCreateNutritionPlan, content: {
//                            CreateNutritionPlanView()
//                        })
//                    }
//                } header: {
//                    Text("Nutrition")
//                        .font(Font.FontStyles.title3)
//                        .foregroundStyle(Color.ColorSystem.primaryText)
//                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
//                }
            }
            .listStyle(.plain)
            .listRowSeparator(.hidden)
            .scrollContentBackground(.hidden)
            .navigationBarTitleDisplayMode(.inline)
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
                case .PostsView:
                    let vm = UserPostsViewModel(userId: destination.getId())
                    UserPostsView(viewModel: vm)
                case .PostDetail:
                    let vm = PostDetailViewModel(post: destination.getPost())
                    PostDetailView(viewModel: vm)
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
                    let vm = ExerciseDetailViewModel(workoutExercise: destination.getWorkoutExercise())
                    ExerciseDetailView(viewModel: vm)
                }
            })
        }
    }
}

#Preview {
    TrainingView()
        .environmentObject(UserViewModel())
}
