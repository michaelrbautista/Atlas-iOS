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
    
    @State var path = [RootNavigationTypes]()
    
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
                                NavigationLink(value: RootNavigationTypes.ProgramWorkoutDetailView(workoutId: workout.id)) {
                                    WorkoutCell(title: workout.title, description: workout.description)
                                }
                                .listRowBackground(Color.ColorSystem.systemBackground)
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
            .rootNavigationDestination(path: $path)
        }
    }
}

#Preview {
    TrainingView()
        .environmentObject(UserViewModel())
}
