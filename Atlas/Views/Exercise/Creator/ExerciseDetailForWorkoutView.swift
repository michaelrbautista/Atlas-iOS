//
//  ExerciseDetailForWorkoutView.swift
//  Atlas
//
//  Created by Michael Bautista on 12/15/24.
//

import SwiftUI

struct ExerciseDetailForWorkoutView: View {
    @Environment(\.dismiss) var dismiss
    
    // Video data
    @State var presentVideoPlayer = false
    
    @StateObject var viewModel: ExerciseDetailForWorkoutViewModel
    
//    var addProgram: ((Program) -> Void)
    
    var body: some View {
        List {
            if let videoUrl = viewModel.exercise.videoUrl {
                Section {
                    VideoCell(videoUrl: URL(string: videoUrl)!) {
                        presentVideoPlayer.toggle()
                    }
                    .listRowBackground(Color.ColorSystem.systemBackground)
                }
            }
            
            // MARK: Name
            Section {
                Text(viewModel.exercise.title)
                    .font(Font.FontStyles.title1)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .listRowBackground(Color.ColorSystem.systemBackground)
            }
            
            // MARK: Instructions
            if let instructions = viewModel.exercise.instructions {
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
                    .disabled(viewModel.isAdding)
            } header: {
                Text("Sets")
            }
            
            // MARK: Reps
            Section {
                TextField("", text: $viewModel.reps, axis: .vertical)
                    .textInputAutocapitalization(.sentences)
                    .foregroundStyle(Color.ColorSystem.primaryText)
                    .listRowBackground(Color.ColorSystem.systemGray6)
                    .disabled(viewModel.isAdding)
            } header: {
                Text("Reps")
            }
            
            // MARK: Time
            Section {
                TextField("", text: $viewModel.time, axis: .vertical)
                    .textInputAutocapitalization(.sentences)
                    .foregroundStyle(Color.ColorSystem.primaryText)
                    .listRowBackground(Color.ColorSystem.systemGray6)
                    .disabled(viewModel.isAdding)
            } header: {
                Text("Time")
            }
            
            // MARK: Other notes
            Section {
                TextEditor(text: $viewModel.other)
                    .frame(height: 120)
                    .listRowBackground(Color.ColorSystem.systemGray6)
                    .listRowInsets(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
                    .disabled(viewModel.isAdding)
            } header: {
                Text("Other notes")
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.ColorSystem.systemBackground)
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                if !viewModel.isAdding {
                    Button {
                        Task {
                            let newExercise = await viewModel.addExerciseToWorkout()
                            
                            if !viewModel.didReturnError && newExercise != nil {
                                dismiss()
                            }
                        }
                    } label: {
                        Text("Add")
                    }
                    .disabled(viewModel.isAdding)
                } else {
                    ProgressView()
                        .tint(Color.ColorSystem.primaryText)
                }
            }
        })
        .fullScreenCover(isPresented: $presentVideoPlayer, content: {
            if let url = viewModel.exercise.videoUrl {
                WatchVideoView(videoUrl: url)
            }
        })
    }
}

#Preview {
    ExerciseDetailForWorkoutView(viewModel: ExerciseDetailForWorkoutViewModel(workoutId: "", programWorkoutId: "", exercise: FetchedExercise(id: "", title: ""), exerciseNumber: 1))
}
