//
//  NewWorkoutView.swift
//  Atlas
//
//  Created by Michael Bautista on 4/14/24.
//

import SwiftUI

struct NewWorkoutView: View {
    // MARK: UI state
    @StateObject var viewModel: NewWorkoutViewModel
    @Environment(\.dismiss) private var dismiss
    @FocusState var keyboardIsFocused: Bool
    
    public var onWorkoutCreated: ((Workout) -> Void)
    
    var body: some View {
        NavigationStack {
            List {
                // MARK: Text Field
                Section {
                    TextField("Title", text: $viewModel.title, axis: .vertical)
                        .foregroundStyle(Color.ColorSystem.primaryText)
                        .listRowBackground(Color.ColorSystem.systemGray4)
                        .disabled(viewModel.isSaving)
                } header: {
                    Text("Title")
                }
                
                // MARK: Is Free
                Section {
                    Toggle(isOn: $viewModel.isFree, label: {
                        Text("Free Workout")
                            .font(Font.FontStyles.body)
                            .foregroundStyle(Color.ColorSystem.primaryText)
                    })
                    .toggleStyle(SwitchToggleStyle(tint: .green))
                    .listRowBackground(Color.ColorSystem.systemGray4)
                } footer: {
                    Text("Users will be able to see this workout without purchasing the program.")
                }
                
                // MARK: Text Field
                Section {
                    TextField("", text: $viewModel.description, prompt: viewModel.description == "" ? Text("Add description...") : Text(""), axis: .vertical)
                        .lineLimit(12...)
                        .listRowBackground(Color.ColorSystem.systemGray4)
                        .disabled(viewModel.isSaving)
                } header: {
                    Text("Description")
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("New Workout")
            .background(Color.ColorSystem.systemGray5)
            .alert(isPresented: $viewModel.didReturnError, content: {
                Alert(title: Text(viewModel.returnedErrorMessage ?? "Couldn't save workout."))
            })
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .tint(Color.ColorSystem.primaryText)
                    .disabled(viewModel.isSaving)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    if viewModel.isSaving {
                        ProgressView()
                            .foregroundStyle(Color.ColorSystem.primaryText)
                    } else {
                        Button("Save") {
                            keyboardIsFocused = false
                            
                            // Save workout
                            Task {
                                let savedWorkout = await viewModel.createNewWorkout()
                                
                                if let savedWorkout = savedWorkout {
                                    self.onWorkoutCreated(savedWorkout)
                                    dismiss()
                                }
                            }
                        }
                        .tint(Color.ColorSystem.systemBlue)
                        .disabled(viewModel.title == "")
                    }
                }
            })
        }
    }
}

#Preview {
    NewWorkoutView(viewModel: NewWorkoutViewModel(sectionId: "asdf", workoutNumber: 2), onWorkoutCreated: {_ in})
}
