//
//  LibraryExerciseDetailView.swift
//  stayhard
//
//  Created by Michael Bautista on 3/31/24.
//

import SwiftUI
import PhotosUI
import AVKit

struct LibraryExerciseDetailView: View {
    @StateObject var viewModel: LibraryExerciseDetailViewModel
    
    @State var presentEditExercise = false
    @State var presentDeleteExercise = false
    @State var presentVideoPlayer = false
    
    @Binding var path: [RootNavigationTypes]
    
    var body: some View {
        List {
            // MARK: Video
            if viewModel.exercise.videoUrl != nil {
                if viewModel.exerciseVideo != nil {
                    Section {
                        VideoCellFromData(videoData: viewModel.exerciseVideo!) {
                            presentVideoPlayer.toggle()
                        }
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .listRowBackground(Color.ColorSystem.systemBackground)
                    }
                } else {
                    HStack {
                        Spacer()
                        ProgressView()
                            .frame(width: 160, height: 200)
                            .tint(Color.ColorSystem.primaryText)
                            .background(Color.ColorSystem.systemGray6)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        Spacer()
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
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
            if viewModel.exercise.instructions != nil {
                Section {
                    Text(viewModel.exercise.instructions!)
                        .font(Font.FontStyles.body)
                        .foregroundStyle(Color.ColorSystem.primaryText)
                        .listRowBackground(Color.ColorSystem.systemGray6)
                } header: {
                    Text("Instructions")
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.ColorSystem.systemBackground)
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                if !viewModel.isDeleting {
                    Menu {
                        Button {
                            presentEditExercise.toggle()
                        } label: {
                            Text("Edit exercise")
                        }
                        
                        Button {
                            presentDeleteExercise.toggle()
                        } label: {
                            Text("Delete exercise")
                                .foregroundStyle(Color.ColorSystem.systemRed)
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                } else {
                    ProgressView()
                        .tint(Color.ColorSystem.primaryText)
                }
            }
        })
        .alert(Text("Are you sure you want to delete this exercise? This will remove this exercise from any workouts it was added to and cannot be undone."), isPresented: $presentDeleteExercise) {
            Button(role: .destructive) {
                Task {
                    await viewModel.deleteExercise()
                }
                
                path.removeLast(1)
            } label: {
                Text("Yes")
            }
        }
        .fullScreenCover(isPresented: $presentVideoPlayer, content: {
            if let url = viewModel.exercise.videoUrl {
                WatchVideoView(videoUrl: url)
            }
        })
        .sheet(isPresented: $presentEditExercise) {
            EditLibraryExerciseView(viewModel: EditLibraryExerciseViewModel(exercise: viewModel.exercise, exerciseVideo: viewModel.exerciseVideo))
        }
    }
}

#Preview {
    LibraryExerciseDetailView(viewModel: LibraryExerciseDetailViewModel(exercise: FetchedExercise(id: "", title: "Test")), path: .constant([]))
}
