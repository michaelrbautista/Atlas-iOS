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
    
    @State private var presentNewExercise = false
    @State private var presentEditWorkout = false
    @State private var presentDeleteWorkout = false
    
    var deleteProgramWorkout: (() -> Void)?
    
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
                                    navigationController.push(.WorkoutExerciseDetailView(workoutExercise: exercise, deleteWorkoutExercise: {
                                        viewModel.programWorkout?.workoutExercises?.remove(exercise)
                                    }))
                                }
                            }
                            .onDelete { indexSet in
                                // Delete and remove workout
                                let exerciseIndex = indexSet[indexSet.startIndex]
                                
                                Task {
                                    await viewModel.deleteExercise(exerciseId: viewModel.programWorkout!.workoutExercises![exerciseIndex].id, exerciseNumber: viewModel.programWorkout!.workoutExercises![exerciseIndex].exerciseNumber, indexSet: indexSet)
                                }
                            }
                        } header: {
                            HStack {
                                Text("Exercises")
                                    .font(Font.FontStyles.title3)
                                    .foregroundStyle(Color.ColorSystem.primaryText)
                                
                                Spacer()
                                
                                if viewModel.isCreator {
                                    Button {
                                        navigationController.presentSheet(.AddExerciseToWorkoutCoordinatorView(workoutId: nil, programWorkoutId: viewModel.programWorkout!.id, exerciseNumber: (viewModel.programWorkout!.workoutExercises?.count ?? 0) + 1, addExerciseToWorkout: { newWorkoutExercise in
                                            viewModel.programWorkout?.workoutExercises?.append(newWorkoutExercise)
                                        }))
                                    } label: {
                                        Image(systemName: "plus")
                                    }
                                    
                                }
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
            .toolbar(content: {
                if viewModel.isCreator {
                    ToolbarItem(placement: .topBarTrailing) {
                        if !viewModel.isDeleting {
                            Menu {
                                Button {
                                    navigationController.presentSheet(.EditProgramWorkoutView(programWorkout: viewModel.programWorkout!, editProgramWorkout: { newWorkout in
                                        viewModel.programWorkout = newWorkout
                                    }))
                                } label: {
                                    Text("Edit workout")
                                }
                                
                                Button {
                                    presentDeleteWorkout.toggle()
                                } label: {
                                    Text("Delete workout")
                                        .foregroundStyle(Color.ColorSystem.systemRed)
                                }
                            } label: {
                                Image(systemName: "ellipsis")
                            }
                        } else {
                            ProgressView()
                                .tint(Color.ColorSystem.primaryText)
                        }
                    }
                }
            })
            .alert(Text("Are you sure you want to delete this workout? This action cannot be undone."), isPresented: $presentDeleteWorkout) {
                Button(role: .destructive) {
                    Task {
                        await viewModel.deleteWorkout()
                    }
                    
                    navigationController.pop()
                } label: {
                    Text("Yes")
                }
            }
        }
    }
}

#Preview {
    ProgramWorkoutDetailView(viewModel: ProgramWorkoutDetailViewModel(programWorkoutId: "e1de3869-8dec-42af-9c71-e5d2071c539c"))
}
