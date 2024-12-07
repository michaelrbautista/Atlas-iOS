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
                if viewModel.workout!.programExercises!.count > 0 {
                    Section {
                        ForEach(viewModel.workout!.programExercises ?? [FetchedProgramExercise]()) { exercise in
                            NavigationLink(value: NavigationDestinationTypes.ExerciseDetailView(programExercise: exercise)) {
                                ExerciseCell(
                                    exercise: exercise
                                )
                            }
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
        }
    }
}

#Preview {
    WorkoutDetailView(viewModel: WorkoutDetailViewModel(workoutId: "Test"))
        .environmentObject(ProgramDetailViewModel(programId: ""))
}
