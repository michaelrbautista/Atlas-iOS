//
//  LibraryWorkoutDetailView.swift
//  stayhard
//
//  Created by Michael Bautista on 3/20/24.
//

import SwiftUI

struct LibraryWorkoutDetailView: View {
    @StateObject var viewModel: LibraryWorkoutDetailViewModel
    
    @State private var presentNewExercise = false
    @State private var presentEditWorkout = false
    @State private var presentDeleteWorkout = false
    
    @Binding var path: [RootNavigationTypes]
    
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
                        ForEach(exercises) { exercise in
                            NavigationLink(value: RootNavigationTypes.ProgramExerciseDetailView(workoutExercise: exercise)) {
                                if let libraryExercise = exercise.exercises {
                                    ExerciseCell(exerciseNumber: exercise.exerciseNumber, name: libraryExercise.title, sets: exercise.sets ?? 1, reps: exercise.reps ?? 1)
                                }
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
                                    presentNewExercise.toggle()
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
                                presentEditWorkout.toggle()
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
                    }
                    
                    path.removeLast(1)
                } label: {
                    Text("Yes")
                }
            }
            .sheet(isPresented: $presentNewExercise) {
                AddExerciseToWorkoutView(viewModel: AddExerciseToWorkoutViewModel(workoutId: viewModel.libraryWorkout!.id, programWorkoutId: nil, exerciseNumber: (viewModel.libraryWorkout!.workoutExercises?.count ?? 0) + 1))
            }
            .sheet(isPresented: $presentEditWorkout) {
                EditWorkoutView(viewModel: EditWorkoutViewModel(isProgramWorkout: false, workout: EditWorkoutRequest(id: viewModel.libraryWorkout!.id, title: viewModel.libraryWorkout!.title, description: viewModel.libraryWorkout!.description)))
            }
        }
    }
}

#Preview {
    LibraryWorkoutDetailView(viewModel: LibraryWorkoutDetailViewModel(libraryWorkoutId: "Test"), path: .constant([]))
}
