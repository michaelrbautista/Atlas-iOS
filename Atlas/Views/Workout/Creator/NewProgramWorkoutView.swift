//
//  NewProgramWorkoutView.swift
//  Atlas
//
//  Created by Michael Bautista on 12/8/24.
//

import SwiftUI

struct NewProgramWorkoutView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel: NewProgramWorkoutViewModel
    
    @State var path = [SheetNavigationTypes]()
    
    var body: some View {
        NavigationStack {
            List {
                // MARK: Library workouts link
                Section {
                    NavigationLink(value: SheetNavigationTypes.LibraryWorkoutsForProgramView(programId: viewModel.programId, week: viewModel.week, day: viewModel.day)) {
                        Text("Library Workouts")
                    }
                    .listRowBackground(Color.ColorSystem.systemGray6)
                    .listRowSeparator(.hidden)
                }
                
                // MARK: Title
                Section {
                    TextField("", text: $viewModel.title, axis: .vertical)
                        .textInputAutocapitalization(.sentences)
                        .foregroundStyle(Color.ColorSystem.primaryText)
                        .listRowBackground(Color.ColorSystem.systemGray6)
                        .disabled(viewModel.isSaving)
                } header: {
                    Text("Title")
                }
                
                // MARK: Description
                Section {
                    TextEditor(text: $viewModel.description)
                        .frame(height: 120)
                        .listRowBackground(Color.ColorSystem.systemGray6)
                        .listRowInsets(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
                        .disabled(viewModel.isSaving)
                } header: {
                    Text("Description")
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .scrollDismissesKeyboard(.interactively)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Add Workout")
            .background(Color.ColorSystem.systemBackground)
            .interactiveDismissDisabled(viewModel.isSaving)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .foregroundStyle(Color.ColorSystem.primaryText)
                    }
                    .disabled(viewModel.isSaving)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task {
                            let newWorkout = await viewModel.addNewWorkout()
                            
                            if !viewModel.didReturnError && newWorkout != nil {
//                                addProgram(newProgram!)
                                dismiss()
                            }
                        }
                    } label: {
                        if !viewModel.isSaving {
                            Text("Save")
                                .foregroundStyle(viewModel.title != "" ? Color.ColorSystem.systemBlue : Color.ColorSystem.systemGray3)
                        } else {
                            ProgressView()
                                .foregroundStyle(Color.ColorSystem.primaryText)
                        }
                    }
                    .disabled(viewModel.isSaving || viewModel.title == "")
                }
            }
            .alert(isPresented: $viewModel.didReturnError, content: {
                Alert(title: Text(viewModel.returnedErrorMessage))
            })
            .sheetNavigationDestination(path: $path)
        }
    }
}

#Preview {
    NewProgramWorkoutView(viewModel: NewProgramWorkoutViewModel(programId: "", week: 9, day: "monday"))
}
