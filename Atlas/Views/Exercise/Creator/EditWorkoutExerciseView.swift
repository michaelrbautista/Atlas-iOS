//
//  EditWorkoutExerciseView.swift
//  Atlas
//
//  Created by Michael Bautista on 12/23/24.
//

import SwiftUI
import PhotosUI

struct EditWorkoutExerciseView: View {
    @EnvironmentObject var navigationController: NavigationController
    @StateObject var viewModel: EditWorkoutExerciseViewModel
    
    @State var presentVideoPlayer = false
    
    var editWorkoutExercise: ((FetchedWorkoutExercise) -> Void)
    
    var body: some View {
        NavigationStack {
            List {
                if let videoUrl = viewModel.videoUrl {
                    Section {
                        VideoCell(videoUrl: videoUrl, onPlay: {
                            presentVideoPlayer.toggle()
                        })
                        .listRowBackground(Color.ColorSystem.systemBackground)
                    }
                }
                
                // MARK: Name
                Section {
                    Text(viewModel.exercise.exercises!.title)
                        .font(Font.FontStyles.title1)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .listRowBackground(Color.ColorSystem.systemBackground)
                }
                
                // MARK: Instructions
                if let instructions = viewModel.exercise.exercises!.instructions {
                    Section {
                        Text(instructions)
                            .font(Font.FontStyles.body)
                            .foregroundStyle(Color.ColorSystem.primaryText)
                            .listRowBackground(Color.ColorSystem.systemGray6)
                    }
                }
                
                // MARK: Sets
                Section {
                    TextField("", text: $viewModel.sets, axis: .vertical)
                        .textInputAutocapitalization(.sentences)
                        .foregroundStyle(Color.ColorSystem.primaryText)
                        .listRowBackground(Color.ColorSystem.systemGray6)
                        .disabled(viewModel.isSaving)
                } header: {
                    Text("Sets")
                }
                
                // MARK: Reps
                Section {
                    TextField("", text: $viewModel.reps, axis: .vertical)
                        .textInputAutocapitalization(.sentences)
                        .foregroundStyle(Color.ColorSystem.primaryText)
                        .listRowBackground(Color.ColorSystem.systemGray6)
                        .disabled(viewModel.isSaving)
                } header: {
                    Text("Reps")
                }
                
                // MARK: Time
                Section {
                    TextField("", text: $viewModel.time, axis: .vertical)
                        .textInputAutocapitalization(.sentences)
                        .foregroundStyle(Color.ColorSystem.primaryText)
                        .listRowBackground(Color.ColorSystem.systemGray6)
                        .disabled(viewModel.isSaving)
                } header: {
                    Text("Time")
                }
                
                // MARK: Other notes
                Section {
                    TextEditor(text: $viewModel.other)
                        .frame(height: 120)
                        .listRowBackground(Color.ColorSystem.systemGray6)
                        .listRowInsets(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
                        .disabled(viewModel.isSaving)
                } header: {
                    Text("Other notes")
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .scrollDismissesKeyboard(.interactively)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("New Exercise")
            .background(Color.ColorSystem.systemBackground)
            .interactiveDismissDisabled(viewModel.isSaving)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        navigationController.dismissSheet()
                    } label: {
                        Text("Cancel")
                            .foregroundStyle(Color.ColorSystem.primaryText)
                    }
                    .disabled(viewModel.isSaving)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task {
                            let newExercise = await viewModel.saveExercise()
                            
                            if !viewModel.didReturnError && newExercise != nil {
                                self.editWorkoutExercise(newExercise!)
                                navigationController.dismissSheet()
                            }
                        }
                    } label: {
                        if !viewModel.isSaving {
                            Text("Save")
                                .foregroundStyle(Color.ColorSystem.systemBlue)
                        } else {
                            ProgressView()
                                .foregroundStyle(Color.ColorSystem.primaryText)
                        }
                    }
                    .disabled(viewModel.isSaving)
                }
            }
            .fullScreenCover(isPresented: $presentVideoPlayer, content: {
                if let url = viewModel.videoUrl {
                    WatchVideoView(videoUrl: url.absoluteString)
                }
            })
            .alert(isPresented: $viewModel.didReturnError, content: {
                Alert(title: Text(viewModel.returnedErrorMessage))
            })
        }
    }
}

#Preview {
    EditWorkoutExerciseView(viewModel: EditWorkoutExerciseViewModel(exercise: FetchedWorkoutExercise(id: "", createdBy: "", exerciseId: "", exerciseNumber: 3))) {_ in}
}
