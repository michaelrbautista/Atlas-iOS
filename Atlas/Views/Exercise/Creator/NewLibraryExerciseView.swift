//
//  NewLibraryExerciseView.swift
//  Atlas
//
//  Created by Michael Bautista on 12/14/24.
//

import SwiftUI
import PhotosUI

struct NewLibraryExerciseView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel = NewLibraryExerciseViewModel()
    
    @State var presentVideoPlayer = false
    
    // FetchedWorkout: newly created workout
    var addExercise: ((FetchedExercise) -> Void)
    
    var body: some View {
        NavigationStack {
            List {
                // MARK: Video
                if let video = viewModel.exerciseVideo {
                    Section {
                        VideoCellFromData(videoData: video) {
                            presentVideoPlayer.toggle()
                        }
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .listRowBackground(Color.ColorSystem.systemBackground)
                    }
                }
                
                Section {
                    if viewModel.videoSelection != nil {
                        Button(action: {
                            viewModel.exerciseVideo = nil
                            viewModel.videoSelection = nil
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
                        .disabled(viewModel.isLoading)
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
                        .listRowBackground(Color.ColorSystem.systemGray6)
                        .disabled(viewModel.isLoading)
                    }
                }
                
                // MARK: Title
                Section {
                    TextField("", text: $viewModel.name, axis: .vertical)
                        .textInputAutocapitalization(.sentences)
                        .foregroundStyle(Color.ColorSystem.primaryText)
                        .listRowBackground(Color.ColorSystem.systemGray6)
                        .disabled(viewModel.isLoading)
                } header: {
                    Text("Title")
                }
                
                // MARK: Instructions
                Section {
                    TextEditor(text: $viewModel.instructions)
                        .frame(height: 120)
                        .listRowBackground(Color.ColorSystem.systemGray6)
                        .listRowInsets(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
                } header: {
                    Text("Instructions")
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .scrollDismissesKeyboard(.interactively)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("New Exercise")
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
                            let newExercise = await viewModel.saveExercise()
                            
                            if !viewModel.didReturnError && newExercise != nil {
                                addExercise(newExercise!)
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
    NewLibraryExerciseView(addExercise: { exercise in })
}
