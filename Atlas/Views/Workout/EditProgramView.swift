//
//  EditProgramView.swift
//  stayhard
//
//  Created by Michael Bautista on 4/1/24.
//

import SwiftUI
import PhotosUI

struct EditProgramView: View {
    // MARK: UI state
    @Environment(\.dismiss) private var dismiss
    @FocusState var keyboardIsFocused: Bool
    
    // MARK: Data
    @StateObject var viewModel: EditProgramViewModel
    
    public var onProgramEdited: ((UIImage, Program) -> Void)?
    
    var body: some View {
        NavigationStack {
            List {
                // MARK: Image
                Section {
                    VStack {
                        // Photo
                        PhotosPicker(selection: $viewModel.imageSelection, matching: .images) {
                            Image(uiImage: viewModel.programImage)
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
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .listRowSeparator(.hidden)
                }
                .background(Color.ColorSystem.systemGray5)
                
                // MARK: Text Field
                Section {
                    TextField("Title", text: $viewModel.program.title, axis: .vertical)
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
                            if viewModel.program.description == "" {
                                Text("Add description...")
                                    .foregroundStyle(Color.ColorSystem.systemGray1)
                            } else {
                                Text(viewModel.program.description ?? "")
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
                                exercises: workout.exercises) { workout in
                                    viewModel.editWorkout(workout: workout)
                                }
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
                        viewModel.deleteWorkout(offsets: indexSet)
                    })
                    
                    NavigationLink {
                        AddWorkoutView(
                            workoutNumber: viewModel.program.workouts.count) { workout in
                                viewModel.addWorkout(workout: workout)
                            }
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
            .navigationTitle("Edit Program")
            .background(Color.ColorSystem.systemGray5)
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
                            dismiss()
                            
//                            viewModel.saveProgram { programImage, editedProgram in
//                                #warning("Completion handler")
//                            }
                        }
                        .tint(Color.ColorSystem.systemBlue)
                    }
                }
            })
        }
    }
}

#Preview {
    EditProgramView(viewModel: EditProgramViewModel(programImage: UIImage(), program: Program(id: "", title: "", uid: "", dateSaved: Date()), programTitle: "Test", programDescription: "Test", programWorkouts: [Workout]()))
}
