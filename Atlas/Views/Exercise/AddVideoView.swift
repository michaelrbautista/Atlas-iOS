//
//  AddVideoView.swift
//  Atlas
//
//  Created by Michael Bautista on 4/13/24.
//

import SwiftUI
import PhotosUI
import AVKit

struct AddVideoView: View {
    // MARK: UI State
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var viewModel: ProgramDetailViewModel

    @StateObject var videoViewModel = AddVideoViewModel()
    
    // Info to add video to exercise
    var workoutId: Int
    var exerciseId: Int
    
    public var onVideoSaved: ((URL) -> Void)?
    
    var body: some View {
        NavigationStack {
            List {
                if let player = videoViewModel.player {
                    Section {
                        HStack {
                            Spacer()
                            
                            VideoPlayer(player: player)
                                .scaledToFit()
                            
                            Spacer()
                        }
                        .listRowBackground(Color.ColorSystem.systemGray5)
                    }
                }
                
                Section {
                    if videoViewModel.videoSelection != nil {
                        Button(action: {
                            videoViewModel.exerciseVideo = nil
                            videoViewModel.videoSelection = nil
                            videoViewModel.player = nil
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
                    } else {
                        PhotosPicker(selection: $videoViewModel.videoSelection, matching: .videos) {
                            HStack {
                                Spacer()
                                Text("Select video")
                                    .font(Font.FontStyles.body)
                                    .foregroundStyle(Color.ColorSystem.primaryText)
                                Spacer()
                            }
                        }
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .listRowBackground(Color.ColorSystem.systemGray4)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Color.ColorSystem.systemGray5)
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    if videoViewModel.isSaving {
                        ProgressView()
                            .foregroundStyle(Color.ColorSystem.primaryText)
                    } else {
                        Button("Save") {
                            videoViewModel.saveVideo(program: viewModel.program!, workoutId: workoutId, exerciseId: exerciseId) { url in
                                self.onVideoSaved?(url)
                                dismiss()
                            }
                        }
                        .tint(Color.ColorSystem.systemBlue)
                        .disabled(videoViewModel.player == nil)
                    }
                }
            })
        }
    }
}

#Preview {
    AddVideoView(workoutId: 2, exerciseId: 3)
}
