//
//  ExerciseDetailView.swift
//  stayhard
//
//  Created by Michael Bautista on 3/31/24.
//

import SwiftUI
import PhotosUI
import AVKit

struct ExerciseDetailView: View {
    @Environment(\.isPresented) var presentationMode
    
    @EnvironmentObject var programViewModel: ProgramDetailViewModel
    
    // Video data
    @State var presentVideoPlayer = false
    
    @StateObject var viewModel: ExerciseDetailViewModel
    
    var body: some View {
        if viewModel.isLoading == true || viewModel.exercise == nil {
            VStack(alignment: .center) {
                Spacer()
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .tint(Color.ColorSystem.primaryText)
                Spacer()
            }
            .background(Color.ColorSystem.systemBackground)
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $viewModel.didReturnError, content: {
                Alert(title: Text(viewModel.returnedErrorMessage))
            })
        } else {
            List {
                // MARK: Name
                Section {
                    Text(viewModel.exercise!.title)
                        .font(Font.FontStyles.title1)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .listRowBackground(Color.ColorSystem.systemBackground)
                }
                
                // MARK: Video
                if let videoUrl = viewModel.exercise!.videoUrl {
                    VideoCell(videoUrl: URL(string: videoUrl)!) {
                        presentVideoPlayer.toggle()
                    }
                    .listRowBackground(Color.ColorSystem.systemBackground)
                }
                
                Section {
                    Text(viewModel.workoutExercise.sets == 1 ? "\(viewModel.workoutExercise.sets) set" : "\(viewModel.workoutExercise.sets) sets")
                        .font(Font.FontStyles.body)
                        .foregroundStyle(Color.ColorSystem.primaryText)
                        .listRowBackground(Color.ColorSystem.systemGray6)
                    
                    Text(viewModel.workoutExercise.reps == 1 ? "\(viewModel.workoutExercise.reps) rep" : "\(viewModel.workoutExercise.reps) reps")
                        .font(Font.FontStyles.body)
                        .foregroundStyle(Color.ColorSystem.primaryText)
                        .listRowBackground(Color.ColorSystem.systemGray6)
                }
                
                // MARK: Instructions
                if viewModel.exercise!.instructions != "" {
                    Section {
                        Text(viewModel.exercise!.instructions!)
                            .font(Font.FontStyles.body)
                            .foregroundStyle(Color.ColorSystem.primaryText)
                            .listRowBackground(Color.ColorSystem.systemGray6)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.ColorSystem.systemBackground)
            .fullScreenCover(isPresented: $presentVideoPlayer, content: {
                if let url = viewModel.exercise!.videoUrl {
                    VideoViewURL(videoUrl: url)
                }
            })
        }
    }
}

#Preview {
    ExerciseDetailView(viewModel: ExerciseDetailViewModel(workoutExercise: WorkoutExercise(id: "", createdAt: "", createdBy: "", workoutId: "", exerciseId: "", exerciseNumber: 1, title: "", sets: 1, reps: 1)))
        .environmentObject(ProgramDetailViewModel(programId: "beff379c-b74b-4423-8a1f-b14b077b31f3"))
}
