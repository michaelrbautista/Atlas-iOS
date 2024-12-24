//
//  EditProgramWorkoutView.swift
//  Atlas
//
//  Created by Michael Bautista on 12/23/24.
//

import SwiftUI

struct EditProgramWorkoutView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel: EditProgramWorkoutViewModel
    
    var editProgramWorout: ((ProgramWorkout) -> Void)
    
    var body: some View {
        NavigationStack {
            List {
                // MARK: Title
                Section {
                    TextField("", text: $viewModel.title, axis: .vertical)
                        .textInputAutocapitalization(.sentences)
                        .foregroundStyle(Color.ColorSystem.primaryText)
                        .listRowBackground(Color.ColorSystem.systemGray6)
                        .disabled(viewModel.isLoading)
                } header: {
                    Text("Title")
                }
                
                // MARK: Description
                Section {
                    TextEditor(text: $viewModel.description)
                        .frame(height: 120)
                        .listRowBackground(Color.ColorSystem.systemGray6)
                        .listRowInsets(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
                } header: {
                    Text("Description")
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .scrollDismissesKeyboard(.interactively)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("New Workout")
            .background(Color.ColorSystem.systemBackground)
            .interactiveDismissDisabled(viewModel.isLoading)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .foregroundStyle(Color.ColorSystem.primaryText)
                    }
                    .disabled(viewModel.isLoading)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task {
                            let newWorkout = await viewModel.saveProgramWorkout()
                            
                            if !viewModel.didReturnError && newWorkout != nil {
                                self.editProgramWorout(newWorkout!)
                                dismiss()
                            }
                        }
                    } label: {
                        if !viewModel.isLoading {
                            Text("Save")
                                .foregroundStyle(Color.ColorSystem.systemBlue)
                        } else {
                            ProgressView()
                                .foregroundStyle(Color.ColorSystem.primaryText)
                        }
                    }
                    .disabled(viewModel.isLoading)
                }
            }
            .alert(isPresented: $viewModel.didReturnError, content: {
                Alert(title: Text(viewModel.returnedErrorMessage))
            })
        }
    }
}

#Preview {
    EditProgramWorkoutView(viewModel: EditProgramWorkoutViewModel(workout: EditWorkoutRequest(id: "", title: "Test", description: "Test description")), editProgramWorout: {_ in})
}
