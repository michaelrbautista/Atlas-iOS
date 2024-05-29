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
    @EnvironmentObject var viewModel: ProgramDetailViewModel
    
    // Video data
    @State var presentAddVideo = false
    @State var confirmDeleteVideo = false
    var workoutId: Int
    
    // MARK: Exercise data
    @State var exercise: Exercise
    
    var body: some View {
        List {
            // MARK: Name
            Section {
                Text(exercise.title)
                    .font(Font.FontStyles.title1)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            
//            if exercise.videoUrl != nil {
//                if let url = URL(string: exercise.videoUrl!) {
//                    Section {
//                        HStack {
//                            Spacer()
//                            
//                            VideoPlayer(player: AVPlayer(url: url))
//                                .scaledToFit()
//                            
//                            Spacer()
//                        }
//                        .listRowBackground(Color.ColorSystem.systemGray5)
//                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
//                    }
//                }
//            }
            
            Section {
                Text(exercise.sets == "1" ? "\(exercise.sets) set" : "\(exercise.sets) sets")
                    .font(Font.FontStyles.body)
                    .foregroundStyle(Color.ColorSystem.primaryText)
                    .listRowBackground(Color.ColorSystem.systemGray4)
                
                Text(exercise.reps == "1" ? "\(exercise.reps) rep" : "\(exercise.reps) reps")
                    .font(Font.FontStyles.body)
                    .foregroundStyle(Color.ColorSystem.primaryText)
                    .listRowBackground(Color.ColorSystem.systemGray4)
            }
            
            // MARK: Instructions
            if exercise.instructions != "" {
                Section {
                    Text(exercise.instructions)
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
        .sheet(isPresented: $presentAddVideo, content: {
//            AddVideoView(workoutId: workoutId, exerciseId: exercise.id) { videoUrl in
//                viewModel.program!.workouts[workoutId].exercises[exercise.id].videoUrl = videoUrl.absoluteString
//                exercise.videoUrl = videoUrl.absoluteString
//            }
        })
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                // If the current user created the program
//                if UserService.currentUser?.id == viewModel.program?.created_by {
//                    // If the exercise has a video
//                    Menu("", systemImage: "ellipsis") {
//                        if exercise.videoUrl != nil {
//                            Button("Delete video", role: .destructive) {
//                                confirmDeleteVideo.toggle()
//                            }
//                        } else {
//                            Button("Add video", role: .none) {
//                                presentAddVideo.toggle()
//                            }
//                        }
//                    }
//                }
            }
        })
        .alert(Text("Delete video?"), isPresented: $confirmDeleteVideo) {
            Button(role: .destructive) {
//                viewModel.deleteExerciseVideo(workoutId: workoutId, exerciseId: exercise.id) { exercise in
//                    self.exercise = exercise
//                }
            } label: {
                Text("Delete")
            }
        }
    }
}

#Preview {
    EmptyView()
//    ExerciseDetailView(workoutId: 4, exercise: Exercise(id: "", exercise_number: 1, title: "Test exercise", sets: "4", reps: "6", instructions: "Instructions", video_url: "url"))
//        .environmentObject(ProgramDetailViewModel(savedProgram: SavedProgram(program_id: "", saved_by: "", created_by: "")))
}
