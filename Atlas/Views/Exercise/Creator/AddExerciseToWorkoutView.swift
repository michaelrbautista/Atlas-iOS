//
//  AddExerciseToWorkoutView.swift
//  Atlas
//
//  Created by Michael Bautista on 12/15/24.
//

import SwiftUI

struct AddExerciseToWorkoutView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel: AddExerciseToWorkoutViewModel
    
    @State var path = [SheetNavigationTypes]()
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(viewModel.exercises) { exercise in
                    NavigationLink(value: SheetNavigationTypes.ExerciseDetailForWorkoutView(workoutId: viewModel.workoutId, programWorkoutId: viewModel.programWorkoutId, exercise: exercise, exerciseNumber: viewModel.exercises.count + 1)) {
                        WorkoutCell(title: exercise.title, description: exercise.instructions)
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
                        dismiss()
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
            .sheetNavigationDestination(path: $path)
        }
    }
}

#Preview {
    AddExerciseToWorkoutView(viewModel: AddExerciseToWorkoutViewModel(workoutId: "", programWorkoutId: ""))
}
