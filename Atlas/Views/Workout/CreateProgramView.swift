//
//  CreateProgramView.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI
import PhotosUI

struct CreateProgramView: View {
    // MARK: UI state
    @Environment(\.dismiss) private var dismiss
    @FocusState var keyboardIsFocused: Bool
    
    // MARK: Data
    @StateObject var viewModel: CreateProgramViewModel
    
    public var onProgramSaved: ((SavedProgram) -> Void)?
    
    var body: some View {
        NavigationStack {
            List {
                // MARK: Image
                Section {
                    VStack {
                        // Add photo
                        if let image = viewModel.programImage {
                            PhotosPicker(selection: $viewModel.imageSelection, matching: .images) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: UIScreen.main.bounds.size.width / 2, height: UIScreen.main.bounds.size.width / 2, alignment: .center)
                                    .background(Color.ColorSystem.systemGray4)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                    .foregroundStyle(Color.ColorSystem.secondaryText)
                            }
                            .buttonStyle(.plain)
                            .disabled(viewModel.isSaving)
                        } else {
                            PhotosPicker(selection: $viewModel.imageSelection, matching: .images) {
                                Image(systemName: "camera.fill")
                                    .frame(width: UIScreen.main.bounds.size.width / 2, height: UIScreen.main.bounds.size.width / 2, alignment: .center)
                                    .background(Color.ColorSystem.systemGray4)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                    .foregroundStyle(Color.ColorSystem.secondaryText)
                            }
                            .buttonStyle(.plain)
                            .disabled(viewModel.isSaving)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .listRowSeparator(.hidden)
                }
                .background(Color.ColorSystem.systemGray5)
                
                // MARK: Text Field
                Section {
                    TextField("Title", text: $viewModel.programTitle, axis: .vertical)
                        .foregroundStyle(Color.ColorSystem.primaryText)
                        .listRowBackground(Color.ColorSystem.systemGray4)
                        .disabled(viewModel.isSaving)
                } header: {
                    Text("Title")
                }
                
                Section {
                    NavigationLink {
                        TextFieldView(textEntered: $viewModel.programDescription)
                            .toolbarRole(.editor)
                    } label: {
                        HStack() {
                            if viewModel.programDescription == "" {
                                Text("Add description...")
                                    .foregroundStyle(Color.ColorSystem.systemGray1)
                            } else {
                                Text(viewModel.programDescription)
                                    .foregroundStyle(Color.ColorSystem.primaryText)
                                    .lineLimit(1)
                            }
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .listRowBackground(Color.ColorSystem.systemGray4)
                    .disabled(viewModel.isSaving)
                } header: {
                    Text("Description")
                }
                
                // MARK: Workouts
                Section {
                    ForEach(viewModel.programWorkouts) { workout in
                        NavigationLink {
                            EditWorkoutView(
                                workoutNumber: workout.id,
                                workoutTitle: workout.title,
                                workoutDescription: workout.description ?? "",
                                exercises: workout.exercises,
                                onWorkoutSaved: { workout in
                                    viewModel.editWorkout(workout: workout)
                                })
                            .toolbarRole(.editor)
                        } label: {
                            HStack {
                                Text(workout.title)
                                    .font(Font.FontStyles.body)
                                    .foregroundStyle(Color.ColorSystem.primaryText)
                                Spacer()
                            }
                        }
                        .listRowBackground(Color.ColorSystem.systemGray4)
                    }
                    .onDelete(perform: { indexSet in
                        self.viewModel.deleteWorkout(offsets: indexSet)
                    })
                    
                    NavigationLink {
                        AddWorkoutView(
                            workoutNumber: viewModel.programWorkouts.count,
                            onWorkoutAdded: { workout in
                                viewModel.addWorkout(workout: workout)
                            })
                        .toolbarRole(.editor)
                    } label: {
                        HStack {
                            Text("Add workout")
                                .foregroundStyle(Color.ColorSystem.systemBlue)
                            Spacer()
                        }
                    }
                    .listRowBackground(Color.ColorSystem.systemGray4)
                    .disabled(viewModel.isSaving)
                } header: {
                    Text("Workouts")
                        .foregroundStyle(Color.ColorSystem.primaryText)
                }
                .headerProminence(.increased)
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("New Program")
            .background(Color.ColorSystem.systemGray5)
            .alert(isPresented: $viewModel.didReturnError, content: {
                Alert(title: Text(viewModel.returnedErrorMessage ?? "Couldn't save program."))
            })
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        keyboardIsFocused = false
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
                            
                            viewModel.saveProgram { savedProgram in
                                onProgramSaved?(savedProgram!)
                                dismiss()
                            }
                        }
                        .tint(Color.ColorSystem.systemBlue)
                    }
                }
            })
        }
    }
}

#Preview {
    CreateProgramView(viewModel: CreateProgramViewModel(), onProgramSaved: {_ in })
}
