//
//  WorkoutExerciseDetailView.swift
//  Atlas
//
//  Created by Michael Bautista on 12/14/24.
//

import SwiftUI
import PhotosUI
import AVKit

struct WorkoutExerciseDetailView: View {
    // Video data
    @State var presentVideoPlayer = false
    
    @StateObject var viewModel: WorkoutExerciseDetailViewModel
    
    @State var presentEditExercise = false
    
    var body: some View {
        List {
            if let programExercise = viewModel.exercise.exercises {
                if let videoUrl = programExercise.videoUrl {
                    Section {
                        VideoCell(videoUrl: URL(string: videoUrl)!) {
                            presentVideoPlayer.toggle()
                        }
                        .listRowBackground(Color.ColorSystem.systemBackground)
                    }
                }
                
                // MARK: Name
                Section {
                    Text(programExercise.title)
                        .font(Font.FontStyles.title1)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .listRowBackground(Color.ColorSystem.systemBackground)
                }
                
                // MARK: Instructions
                if programExercise.instructions != nil {
                    Section {
                        Text(programExercise.instructions!)
                            .font(Font.FontStyles.body)
                            .foregroundStyle(Color.ColorSystem.primaryText)
                            .listRowBackground(Color.ColorSystem.systemGray6)
                    } header: {
                        Text("Instructions")
                    }
                }
                
                // MARK: Sets
                Section {
                    Text(String(viewModel.exercise.sets ?? 1))
                        .font(Font.FontStyles.body)
                        .foregroundStyle(Color.ColorSystem.primaryText)
                        .listRowBackground(Color.ColorSystem.systemGray6)
                } header: {
                    Text("Sets")
                }
                
                // MARK: Reps
                Section {
                    Text(String(viewModel.exercise.reps ?? 1))
                        .font(Font.FontStyles.body)
                        .foregroundStyle(Color.ColorSystem.primaryText)
                        .listRowBackground(Color.ColorSystem.systemGray6)
                } header: {
                    Text("Reps")
                }
                
                // MARK: Time
                if viewModel.exercise.time != nil && viewModel.exercise.time != "" {
                    Section {
                        Text(viewModel.exercise.time!)
                            .font(Font.FontStyles.body)
                            .foregroundStyle(Color.ColorSystem.primaryText)
                            .listRowBackground(Color.ColorSystem.systemGray6)
                    } header: {
                        Text("Time")
                    }
                }
                
                // MARK: Other notes
                if viewModel.exercise.other != nil && viewModel.exercise.other != "" {
                    Section {
                        Text(viewModel.exercise.other!)
                            .font(Font.FontStyles.body)
                            .foregroundStyle(Color.ColorSystem.primaryText)
                            .listRowBackground(Color.ColorSystem.systemGray6)
                    } header: {
                        Text("Other notes")
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.ColorSystem.systemBackground)
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button {
                        presentEditExercise.toggle()
                    } label: {
                        Text("Edit exercise")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                }
            }
        })
        .fullScreenCover(isPresented: $presentVideoPlayer, content: {
            if let url = viewModel.exercise.exercises?.videoUrl {
                WatchVideoView(videoUrl: url)
            }
        })
        .sheet(isPresented: $presentEditExercise) {
            EditWorkoutExerciseView(viewModel: EditWorkoutExerciseViewModel(exercise: viewModel.exercise)) { newExercise in
                viewModel.exercise = newExercise
            }
        }
    }
}

#Preview {
    WorkoutExerciseDetailView(viewModel: WorkoutExerciseDetailViewModel(exercise: FetchedWorkoutExercise(id: "", exerciseId: "", exerciseNumber: 3)))
}
