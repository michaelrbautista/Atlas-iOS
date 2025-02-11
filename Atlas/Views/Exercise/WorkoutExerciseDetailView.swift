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
    @EnvironmentObject var navigationController: NavigationController
    @StateObject var viewModel: WorkoutExerciseDetailViewModel
    
    @State var presentVideoPlayer = false
    
    var body: some View {
        List {
            if let programExercise = viewModel.workoutExercise.exercises {
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
                    Text(String(viewModel.workoutExercise.sets ?? 1))
                        .font(Font.FontStyles.body)
                        .foregroundStyle(Color.ColorSystem.primaryText)
                        .listRowBackground(Color.ColorSystem.systemGray6)
                } header: {
                    Text("Sets")
                }
                
                // MARK: Reps
                Section {
                    Text(String(viewModel.workoutExercise.reps ?? 1))
                        .font(Font.FontStyles.body)
                        .foregroundStyle(Color.ColorSystem.primaryText)
                        .listRowBackground(Color.ColorSystem.systemGray6)
                } header: {
                    Text("Reps")
                }
                
                // MARK: Time
                if viewModel.workoutExercise.time != nil && viewModel.workoutExercise.time != "" {
                    Section {
                        Text(viewModel.workoutExercise.time!)
                            .font(Font.FontStyles.body)
                            .foregroundStyle(Color.ColorSystem.primaryText)
                            .listRowBackground(Color.ColorSystem.systemGray6)
                    } header: {
                        Text("Time")
                    }
                }
                
                // MARK: Other notes
                if viewModel.workoutExercise.other != nil && viewModel.workoutExercise.other != "" {
                    Section {
                        Text(viewModel.workoutExercise.other!)
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
        .fullScreenCover(isPresented: $presentVideoPlayer, content: {
            if let url = viewModel.workoutExercise.exercises?.videoUrl {
                WatchVideoView(videoUrl: url)
            }
        })
    }
}

#Preview {
    WorkoutExerciseDetailView(viewModel: WorkoutExerciseDetailViewModel(workoutExercise: FetchedWorkoutExercise(id: "", createdBy: "", exerciseId: "", exerciseNumber: 3)))
}
