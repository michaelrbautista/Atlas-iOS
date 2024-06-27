//
//  NewExerciseView.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI
import PhotosUI
import AVKit

struct NewExerciseView: View {
    // MARK: UI state
    @Environment(\.dismiss) private var dismiss
    @FocusState var keyboardIsFocused: Bool
    
    @StateObject var viewModel: NewExerciseViewModel
    
    @State var presentVideoPlayer = false
    
    @State var thumbnail: UIImage? = nil
    
    @State var didReturnError = false
    @State var returnedErrorMessage: String? = nil
    
    public var onExerciseCreated: ((Exercise) -> Void)
    
    var body: some View {
        NavigationStack {
            List {
                // MARK: Video
                if let player = viewModel.player {
                    Section {
                        
                    }
                }
                
                Section {
                    if viewModel.videoSelection != nil {
                        Button(action: {
                            viewModel.exerciseVideo = nil
                            viewModel.videoSelection = nil
                            viewModel.player = nil
                        }, label: {
                            HStack {
                                Spacer()
                                Text("Delete video")
                                    .font(Font.FontStyles.body)
                                    .foregroundStyle(Color.ColorSystem.primaryText)
                                Spacer()
                            }
                        })
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .listRowBackground(Color.ColorSystem.systemRed)
                        .disabled(viewModel.isSaving)
                    } else {
                        PhotosPicker(selection: $viewModel.videoSelection, matching: .videos) {
                            HStack {
                                Spacer()
                                Text("Select video")
                                    .font(Font.FontStyles.body)
                                    .foregroundStyle(Color.ColorSystem.primaryText)
                                Spacer()
                            }
                        }
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .listRowBackground(Color.ColorSystem.systemGray4)
                        .disabled(viewModel.isSaving)
                    }
                }
                
                // MARK: Text Field
                Section {
                    TextField(text: $viewModel.name, prompt: Text("Name")) {
                        Text("Name")
                    }
                    .foregroundStyle(Color.ColorSystem.primaryText)
                    .listRowBackground(Color.ColorSystem.systemGray4)
                    .disabled(viewModel.isSaving)
                } header: {
                    Text("Name")
                }
                
                Section {
                    TextField(text: $viewModel.sets, prompt: Text("Sets")) {
                        Text("Sets")
                    }
                    .foregroundStyle(Color.ColorSystem.primaryText)
                    .listRowBackground(Color.ColorSystem.systemGray4)
                    .disabled(viewModel.isSaving)
                } header: {
                    Text("Sets")
                }
                
                Section {
                    TextField(text: $viewModel.reps, prompt: Text("Reps")) {
                        Text("Reps")
                    }
                    .foregroundStyle(Color.ColorSystem.primaryText)
                    .listRowBackground(Color.ColorSystem.systemGray4)
                    .disabled(viewModel.isSaving)
                } header: {
                    Text("Reps")
                }
                
                // MARK: Text Field
                Section {
                    TextField("", text: $viewModel.instructions, prompt: viewModel.instructions == "" ? Text("Add instructions...") : Text(""), axis: .vertical)
                        .lineLimit(16...)
                        .listRowBackground(Color.ColorSystem.systemGray4)
                        .disabled(viewModel.isSaving)
                } header: {
                    Text("Instructions")
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("New Exercise")
            .background(Color.ColorSystem.systemGray5)
            .fullScreenCover(isPresented: $presentVideoPlayer, content: {
                if let url = viewModel.exercise.videoUrl {
                    VideoViewURL(videoUrl: url)
                }
            })
            .alert(isPresented: $viewModel.didReturnError, content: {
                Alert(title: Text(viewModel.returnedErrorMessage ?? "Couldn't save exercise."))
            })
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .disabled(viewModel.isSaving)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    if viewModel.isSaving {
                        ProgressView()
                            .foregroundStyle(Color.ColorSystem.primaryText)
                    } else {
                        Button("Save") {
                            keyboardIsFocused = false
                            
                            // Save exercise
                            Task {
                                if let savedExercise = await viewModel.createNewExercise() {
                                    
                                    self.onExerciseCreated(savedExercise)
                                    
                                    dismiss()
                                }
                            }
                        }
                        .tint(Color.ColorSystem.systemBlue)
                        .disabled(viewModel.name == "")
                    }
                }
            })
        }
    }
}

#Preview {
    NewExerciseView(viewModel: NewExerciseViewModel(workoutId: "test", exerciseNumber: 8), onExerciseCreated: {_ in })
}
