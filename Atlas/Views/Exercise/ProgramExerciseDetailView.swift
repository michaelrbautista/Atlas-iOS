//
//  ProgramExerciseDetailView.swift
//  Atlas
//
//  Created by Michael Bautista on 12/14/24.
//

import SwiftUI
import PhotosUI
import AVKit

struct ProgramExerciseDetailView: View {
    // Video data
    @State var presentVideoPlayer = false
    
    @StateObject var viewModel: ProgramExerciseDetailViewModel
    
    var body: some View {
        List {
            if let libraryExercise = viewModel.exercise.exercises {
                if let videoUrl = libraryExercise.videoUrl {
                    Section {
                        VideoCell(videoUrl: URL(string: videoUrl)!) {
                            presentVideoPlayer.toggle()
                        }
                        .listRowBackground(Color.ColorSystem.systemBackground)
                    }
                }
                
                // MARK: Name
                Section {
                    Text(libraryExercise.title)
                        .font(Font.FontStyles.title1)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .listRowBackground(Color.ColorSystem.systemBackground)
                }
                
                // MARK: Instructions
                if libraryExercise.instructions != nil {
                    Section {
                        Text(libraryExercise.instructions!)
                            .font(Font.FontStyles.body)
                            .foregroundStyle(Color.ColorSystem.primaryText)
                            .listRowBackground(Color.ColorSystem.systemGray6)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.ColorSystem.systemBackground)
        .fullScreenCover(isPresented: $presentVideoPlayer, content: {
            if let url = viewModel.exercise.exercises?.videoUrl {
                WatchVideoView(videoUrl: url)
            }
        })
    }
}

#Preview {
    ProgramExerciseDetailView(viewModel: ProgramExerciseDetailViewModel(exercise: FetchedWorkoutExercise(id: "", exerciseId: "", exerciseNumber: 3)))
}
