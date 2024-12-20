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

    @StateObject var viewModel = AddVideoViewModel()
    
    // Info to add video to exercise
    var workoutId: Int
    var exerciseId: Int
    
    public var onVideoSaved: ((URL) -> Void)?
    
    var body: some View {
        List {
            if let player = viewModel.player {
                Section {
                    HStack {
                        Spacer()
                        
                        VideoPlayer(player: player)
                            .scaledToFit()
                        
                        Spacer()
                    }
                    .listRowBackground(Color.ColorSystem.systemGray6)
                }
            }
            
            Section {
                if viewModel.videoSelection != nil {
                    Button(action: {
                        viewModel.exerciseVideo = nil
                        viewModel.videoSelection = nil
                        viewModel.player = nil
                    }, label: {
                        Text("Delete video")
                            .foregroundStyle(Color.ColorSystem.primaryText)
                    })
                    .frame(maxWidth: .infinity)
                    .padding(12)
                    .background(Color.ColorSystem.systemRed)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                } else {
                    PhotosPicker(selection: $viewModel.videoSelection, matching: .videos) {
                        Text("Add video")
                            .font(Font.FontStyles.body)
                            .foregroundStyle(Color.ColorSystem.primaryText)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(12)
                    .background(Color.ColorSystem.systemGray5)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(Color.ColorSystem.systemGray5)
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                if viewModel.isSaving {
                    ProgressView()
                        .foregroundStyle(Color.ColorSystem.primaryText)
                } else {
                    Button("Save") {
                        
                    }
                    .tint(Color.ColorSystem.systemBlue)
                    .disabled(viewModel.player == nil)
                }
            }
        })
    }
}

#Preview {
    AddVideoView(workoutId: 2, exerciseId: 3)
}
