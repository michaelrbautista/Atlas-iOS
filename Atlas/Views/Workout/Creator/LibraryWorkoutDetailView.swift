//
//  LibraryWorkoutDetailView.swift
//  stayhard
//
//  Created by Michael Bautista on 3/20/24.
//

import SwiftUI

struct LibraryWorkoutDetailView: View {
    @EnvironmentObject var navigationController: NavigationController
    @StateObject var viewModel: LibraryWorkoutDetailViewModel
    
    @State private var presentNewExercise = false
    @State private var presentDeleteWorkout = false
    
    var deleteLibraryWorkout: (() -> Void)?
    
    var body: some View {
        if viewModel.isLoading == true || viewModel.libraryWorkout == nil {
            VStack(alignment: .center) {
                Spacer()
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .tint(Color.ColorSystem.primaryText)
                Spacer()
            }
            .background(Color.ColorSystem.systemBackground)
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $viewModel.didReturnError, content: {
                Alert(title: Text(viewModel.returnedErrorMessage))
            })
            .onAppear {
                Task {
                    await viewModel.getLibraryWorkout()
                }
            }
        } else {
            List {
                VStack(spacing: 10) {
                    // MARK: Title
                    Text(viewModel.libraryWorkout!.title)
                        .font(Font.FontStyles.title3)
                        .foregroundStyle(Color.ColorSystem.primaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                    
                    // MARK: Description
                    if viewModel.libraryWorkout?.description != "" && viewModel.libraryWorkout?.description != nil {
                        HStack {
                            Text(viewModel.libraryWorkout!.description!)
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .listRowSeparator(.hidden)
                
                // MARK: Exercises
                if let exercises = viewModel.libraryWorkout?.workoutExercises {
                    Section {
                        ForEach(Array(exercises.enumerated()), id: \.offset) { index, exercise in
                            CoordinatorLink {
                                if let libraryExercise = exercise.exercises {
                                    ExerciseCell(exerciseNumber: index + 1, name: libraryExercise.title, sets: exercise.sets ?? 1, reps: exercise.reps ?? 1)
                                }
                            } action: {
                                navigationController.push(.WorkoutExerciseDetailView(workoutExercise: exercise, deleteWorkoutExercise: {
                                    viewModel.libraryWorkout?.workoutExercises?.remove(exercise)
                                }))
                            }
                        }
                        .onDelete { indexSet in
                            // Delete and remove workout
                            let exerciseIndex = indexSet[indexSet.startIndex]
                            
                            Task {
                                await viewModel.deleteExercise(exerciseId: viewModel.libraryWorkout!.workoutExercises![exerciseIndex].id, exerciseNumber: viewModel.libraryWorkout!.workoutExercises![exerciseIndex].exerciseNumber, indexSet: indexSet)
                            }
                        }
                    } header: {
                        HStack {
                            Text("Exercises")
                                .font(Font.FontStyles.title3)
                                .foregroundStyle(Color.ColorSystem.primaryText)
                            
                            Spacer()
                            
                            // MARK: Add exercise
                            if viewModel.isCreator {
                                Button {
                                    navigationController.presentSheet(.AddExerciseToWorkoutCoordinatorView(workoutId: viewModel.libraryWorkout!.id, programWorkoutId: nil, exerciseNumber: (viewModel.libraryWorkout!.workoutExercises?.count ?? 0) + 1, addExerciseToWorkout: { newWorkoutExercise in
                                        viewModel.libraryWorkout?.workoutExercises?.append(newWorkoutExercise)
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
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.ColorSystem.systemBackground)
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    if !viewModel.isDeleting {
                        Menu {
                            Button {
                                navigationController.presentSheet(.EditLibraryWorkoutView(libraryWorkout: self.viewModel.libraryWorkout!, editLibraryWorkout: { newWorkout in
                                    self.viewModel.libraryWorkout = newWorkout
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
            })
            .alert(Text("Are you sure you want to delete this workout? This action cannot be undone."), isPresented: $presentDeleteWorkout) {
                Button(role: .destructive) {
                    Task {
                        await viewModel.deleteWorkout()
                        
                        self.deleteLibraryWorkout?()
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
    LibraryWorkoutDetailView(viewModel: LibraryWorkoutDetailViewModel(libraryWorkoutId: "Test"))
}
