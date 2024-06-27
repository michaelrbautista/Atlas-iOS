//
//  WorkoutDetailView.swift
//  stayhard
//
//  Created by Michael Bautista on 3/20/24.
//

import SwiftUI

struct WorkoutDetailView: View {
    @EnvironmentObject var programViewModel: ProgramDetailViewModel
    
    // MARK: UI State
    @State private var presentNewExercise = false
    @State private var presentEditWorkout = false
    
    @StateObject var viewModel: WorkoutDetailViewModel
    
    var body: some View {
        if viewModel.workoutIsLoading == true || viewModel.workout == nil {
            VStack(alignment: .center) {
                Spacer()
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .tint(Color.ColorSystem.primaryText)
                Spacer()
            }
            .background(Color.ColorSystem.systemGray5)
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $viewModel.didReturnError, content: {
                Alert(title: Text(viewModel.returnedErrorMessage))
            })
        } else {
            List {
                // MARK: Description
                if viewModel.workout?.description != "" {
                    Section {
                        Text(viewModel.workout!.description)
                            .listRowBackground(Color.ColorSystem.systemGray4)
                    } header: {
                        Text(viewModel.workout!.title)
                            .font(Font.FontStyles.title1)
                    }
                    .headerProminence(.increased)
                } else {
                    Section {
                        Text(viewModel.workout!.title)
                            .font(Font.FontStyles.title1)
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    }
                }
                
                // MARK: Exercises
                Section {
                    ForEach(viewModel.workout!.exercises ?? [Exercise]()) { exercise in
                        NavigationLink {
                            ExerciseDetailView(viewModel: ExerciseDetailViewModel(exercise: exercise))
                                .environmentObject(programViewModel)
                        } label: {
                            ExerciseCell(
                                exerciseNumber: exercise.exerciseNumber,
                                exerciseTitle: exercise.name,
                                sets: exercise.sets,
                                reps: exercise.reps
                            )
                        }
                        .listRowBackground(Color.ColorSystem.systemGray4)
                    }
                    
                    if programViewModel.program!.createdBy == UserService.currentUser?.id {
                        Button(action: {
                            presentNewExercise.toggle()
                        }, label: {
                            Text("+ Add exercise")
                                .foregroundStyle(Color.ColorSystem.systemBlue)
                        })
                        .listRowBackground(Color.ColorSystem.systemGray4)
                    }
                } header: {
                    Text("Exercises")
                        .foregroundStyle(Color.ColorSystem.primaryText)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
                .headerProminence(.increased)
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.ColorSystem.systemGray5)
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    if UserService.currentUser?.id == viewModel.workout?.createdBy {
                        Menu("", systemImage: "ellipsis") {
                            Button("Edit", role: .none) {
                                presentEditWorkout.toggle()
                            }
                            
//                            Button("Delete", role: .destructive) {
//                                presentConfirmDelete.toggle()
//                            }
                        }
                    }
                }
            })
            .sheet(isPresented: $presentNewExercise, content: {
                NewExerciseView(viewModel: NewExerciseViewModel(workoutId: viewModel.workout!.id!, exerciseNumber: (viewModel.workout?.exercises?.count ?? 0) + 1)) { exercise in
                    viewModel.workout?.exercises?.append(exercise)
                }
            })
            .sheet(isPresented: $presentEditWorkout, content: {
                EditWorkoutView(viewModel: EditWorkoutViewModel(oldWorkout: viewModel.workout!)) { workout in
                    viewModel.workout?.title = workout.title
                    viewModel.workout?.description = workout.description
                }
            })
        }
    }
}

#Preview {
    WorkoutDetailView(viewModel: WorkoutDetailViewModel(workoutId: "Test"))
        .environmentObject(ProgramDetailViewModel(programId: ""))
}
