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
    @EnvironmentObject var programViewModel: ProgramDetailViewModel
    
    // Video data
    @State var presentEditExercise = false
    @State var presentVideoPlayer = false
    
    @StateObject var viewModel: ExerciseDetailViewModel
    
    var body: some View {
        List {
            // MARK: Name
            Section {
                Text(viewModel.exercise.name)
                    .font(Font.FontStyles.title1)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            
            // MARK: Video
            if let videoUrl = URL(string: viewModel.exercise.videoUrl!) {
                VideoCell(videoUrl: videoUrl) {
                    presentVideoPlayer.toggle()
                }
            }
            
            Section {
                Text(viewModel.exercise.sets == "1" ? "\(viewModel.exercise.sets) set" : "\(viewModel.exercise.sets) sets")
                    .font(Font.FontStyles.body)
                    .foregroundStyle(Color.ColorSystem.primaryText)
                    .listRowBackground(Color.ColorSystem.systemGray4)
                
                Text(viewModel.exercise.reps == "1" ? "\(viewModel.exercise.reps) rep" : "\(viewModel.exercise.reps) reps")
                    .font(Font.FontStyles.body)
                    .foregroundStyle(Color.ColorSystem.primaryText)
                    .listRowBackground(Color.ColorSystem.systemGray4)
            }
            
            // MARK: Instructions
            if viewModel.exercise.instructions != "" {
                Section {
                    Text(viewModel.exercise.instructions)
                        .font(Font.FontStyles.body)
                        .foregroundStyle(Color.ColorSystem.primaryText)
                        .listRowBackground(Color.ColorSystem.systemGray4)
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.ColorSystem.systemGray5)
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                if UserService.currentUser?.id == viewModel.exercise.createdBy {
                    Menu("", systemImage: "ellipsis") {
                        Button("Edit", role: .none) {
                            presentEditExercise.toggle()
                        }
                        
//                            Button("Delete", role: .destructive) {
//                                presentConfirmDelete.toggle()
//                            }
                    }
                }
            }
        })
        .fullScreenCover(isPresented: $presentVideoPlayer, content: {
            if let url = viewModel.exercise.videoUrl {
                VideoViewURL(videoUrl: url)
            }
        })
        .sheet(isPresented: $presentEditExercise, content: {
            EditExerciseView(viewModel: EditExerciseViewModel(oldExercise: viewModel.exercise)) { exercise, newVideo in
                viewModel.exercise = exercise
            }
        })
    }
}

#Preview {
//    EmptyView()
    ExerciseDetailView(viewModel: ExerciseDetailViewModel(exercise: Exercise(createdBy: "", workoutId: "", exerciseNumber: 2, name: "Test Exercise", sets: "2", reps: "2", instructions: "This exercise is just to test videos", videoUrl: "https://ltjnvfgpomlatmtqjxrk.supabase.co/storage/v1/object/public/exercise_videos/640b0902-fec9-449b-aead-8e226c7682db-965909189293864553.mp4?t=2024-06-20T01%3A33%3A11.186Z")))
        .environmentObject(ProgramDetailViewModel(programId: "beff379c-b74b-4423-8a1f-b14b077b31f3"))
}
