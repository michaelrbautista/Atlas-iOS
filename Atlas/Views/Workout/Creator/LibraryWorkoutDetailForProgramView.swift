//
//  LibraryWorkoutDetailForProgramView.swift
//  Atlas
//
//  Created by Michael Bautista on 12/15/24.
//

import SwiftUI

struct LibraryWorkoutDetailForProgramView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel: LibraryWorkoutDetailForProgramViewModel
    
    @Binding var path: [SheetNavigationTypes]
    
    var body: some View {
        if viewModel.isLoading == true || viewModel.workout == nil {
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
                // MARK: Description
                if viewModel.workout!.description != nil {
                    Section {
                        Text(viewModel.workout!.description ?? "")
                            .listRowBackground(Color.ColorSystem.systemGray6)
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
                            .listRowBackground(Color.ColorSystem.systemBackground)
                    }
                }
                
                // MARK: Exercises
                if viewModel.workout!.workoutExercises!.count > 0 {
                    Section {
                        ForEach(viewModel.workout!.workoutExercises ?? [FetchedWorkoutExercise]()) { exercise in
                            NavigationLink(value: RootNavigationTypes.ProgramExerciseDetailView(workoutExercise: exercise)) {
                                if let libraryExercise = exercise.exercises {
                                    ExerciseCell(exerciseNumber: exercise.exerciseNumber, name: libraryExercise.title, sets: exercise.sets ?? 1, reps: exercise.reps ?? 1)
                                }
                            }
                            .listRowBackground(Color.ColorSystem.systemGray6)
                        }
                    } header: {
                        Text("Exercises")
                            .foregroundStyle(Color.ColorSystem.primaryText)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    }
                    .headerProminence(.increased)
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.ColorSystem.systemBackground)
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    if !viewModel.isAdding {
                        Button {
                            Task {
                                let newWorkout = await viewModel.addWorkoutToProgram()
                                
                                if !viewModel.didReturnError && newWorkout != nil {
                                    dismiss()
                                }
                            }
                        } label: {
                            Text("Add")
                        }
                        .disabled(viewModel.isAdding)
                    } else {
                        ProgressView()
                            .tint(Color.ColorSystem.primaryText)
                    }
                }
            })
            .alert(isPresented: $viewModel.didReturnError, content: {
                Alert(title: Text(viewModel.returnedErrorMessage))
            })
        }
    }
}

#Preview {
    LibraryWorkoutDetailForProgramView(viewModel: LibraryWorkoutDetailForProgramViewModel(workoutId: "", programId: "", week: 9, day: ""), path: .constant([]))
}
