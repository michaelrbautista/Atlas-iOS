//
//  AddExerciseToWorkoutView.swift
//  Atlas
//
//  Created by Michael Bautista on 12/15/24.
//

import SwiftUI

struct AddExerciseToWorkoutView: View {
    @EnvironmentObject var navigationController: NavigationController
    @EnvironmentObject var sheetNavigationController: SheetNavigationController
    @StateObject var viewModel: AddExerciseToWorkoutViewModel
    
    // FetchedProgram: newly created program
    var addExerciseToWorkout: ((FetchedWorkoutExercise) -> Void)
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.exercises) { exercise in
                    CoordinatorLink {
                        WorkoutCell(title: exercise.title, description: exercise.instructions)
                    } action: {
                        sheetNavigationController.push(.ExerciseDetailForWorkoutView(workoutId: viewModel.workoutId, programWorkoutId: viewModel.programWorkoutId, exercise: exercise, exerciseNumber: viewModel.exerciseNumber, addExerciseToWorkout: addExerciseToWorkout))
                    }
                    .listRowBackground(Color.ColorSystem.systemBackground)
                }
            }
            .listStyle(.plain)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Add Exercise")
            .scrollContentBackground(.hidden)
            .background(Color.ColorSystem.systemBackground)
            .refreshable(action: {
                await viewModel.pulledRefresh()
            })
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        navigationController.dismissSheet()
                    } label: {
                        Text("Cancel")
                            .foregroundStyle(Color.ColorSystem.primaryText)
                    }
                    .disabled(viewModel.isLoading)
                }
            })
            .alert(isPresented: $viewModel.didReturnError, content: {
                Alert(title: Text(viewModel.returnedErrorMessage))
            })
        }
    }
}

#Preview {
    AddExerciseToWorkoutView(viewModel: AddExerciseToWorkoutViewModel(workoutId: "", programWorkoutId: "", exerciseNumber: 1), addExerciseToWorkout: {_ in})
}
