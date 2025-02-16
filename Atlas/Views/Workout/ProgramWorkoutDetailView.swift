//
//  ProgramWorkoutDetailView.swift
//  stayhard
//
//  Created by Michael Bautista on 3/20/24.
//

import SwiftUI

struct ProgramWorkoutDetailView: View {
    @EnvironmentObject var navigationController: NavigationController
    @StateObject var viewModel: ProgramWorkoutDetailViewModel
    
    var body: some View {
        if viewModel.isLoading {
            LoadingView()
                .onAppear {
                    Task {
                        await viewModel.getProgramWorkout()
                    }
                }
        } else if viewModel.didReturnError {
            ErrorView(errorMessage: viewModel.errorMessage)
        } else {
            List {
                VStack(spacing: 20) {
                    // MARK: Title
                    Text(viewModel.programWorkout!.title)
                        .font(Font.FontStyles.title3)
                        .foregroundStyle(Color.ColorSystem.primaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                    
                    // MARK: Description
                    if viewModel.programWorkout?.description != "" && viewModel.programWorkout?.description != nil {
                        HStack {
                            Text(viewModel.programWorkout!.description!)
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                
                // MARK: Exercises
                if let exercises = viewModel.programWorkout?.workoutExercises {
                    if exercises.count > 0 {
                        Section {
                            ForEach(Array(exercises.enumerated()), id: \.offset) { index, exercise in
                                CoordinatorLink {
                                    if let libraryExercise = exercise.exercises {
                                        ExerciseCell(exerciseNumber: index + 1, name: libraryExercise.title, sets: exercise.sets ?? 1, reps: exercise.reps ?? 1)
                                    }
                                } action: {
                                    navigationController.push(.WorkoutExerciseDetailView(workoutExercise: exercise))
                                }
                            }
                        } header: {
                            HStack {
                                Text("Exercises")
                                    .font(Font.FontStyles.title3)
                                    .foregroundStyle(Color.ColorSystem.primaryText)
                                
                                Spacer()
                            }
                        }
                        .headerProminence(.increased)
                    }
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.ColorSystem.systemBackground)
        }
    }
}

#Preview {
    ProgramWorkoutDetailView(viewModel: ProgramWorkoutDetailViewModel(programWorkoutId: "e1de3869-8dec-42af-9c71-e5d2071c539c"))
}
