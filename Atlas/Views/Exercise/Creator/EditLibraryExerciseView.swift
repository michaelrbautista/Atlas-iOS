//
//  EditLibraryExerciseView.swift
//  Atlas
//
//  Created by Michael Bautista on 12/19/24.
//

import SwiftUI
import PhotosUI

struct EditLibraryExerciseView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel: EditLibraryExerciseViewModel
    
    @State var presentVideoPlayer = false
    
    var editLibraryExercise: ((FetchedExercise) -> Void)
    
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
                    if viewModel.videoSelection != nil || viewModel.exerciseVideo != nil {
                        Button(action: {
                            viewModel.exerciseVideo = nil
                            viewModel.videoSelection = nil
                        }, label: {
                            HStack {
                                Spacer()
                                Text("Remove video")
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
                        .listRowBackground(Color.ColorSystem.systemGray6)
                        .disabled(viewModel.isSaving)
                    }
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
                            let newExercise = await viewModel.saveExercise()
                            
                            if !viewModel.didReturnError && newExercise != nil {
                                self.editLibraryExercise(newExercise!)
                                dismiss()
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
    EditLibraryExerciseView(viewModel: EditLibraryExerciseViewModel(exercise: FetchedExercise(id: "", createdBy: "", title: ""), exerciseVideo: nil), editLibraryExercise: {_ in})
}
