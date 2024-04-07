//
//  AddExerciseVideoView.swift
//  stayhard
//
//  Created by Michael Bautista on 4/2/24.
//

import SwiftUI
import PhotosUI

struct AddExerciseVideoView: View {
    
    @State private var showVideoPicker = false
    
    @State private var exerciseVideo: Data? = nil
    @State private var videoSelection: PhotosPickerItem? = nil
    
    var body: some View {
        List {
            Section {
                PhotosPicker(selection: $videoSelection, matching: .videos) {
                    Image(systemName: "video.fill")
                        .frame(width: UIScreen.main.bounds.size.width / 2, height: UIScreen.main.bounds.size.width / 2, alignment: .center)
                        .background(Color.ColorSystem.systemGray4)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .foregroundStyle(Color.ColorSystem.secondaryText)
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Add Exercise")
        .background(Color.ColorSystem.systemGray5)
    }
    
    private func setVideo(selection: PhotosPickerItem?) {
        guard let selection else {
            return
        }
        
        Task {
            if let data = try? await selection.loadTransferable(type: Data.self) {
                DispatchQueue.main.async {
                    self.exerciseVideo = data
                }
            }
        }
    }
}

#Preview {
    AddExerciseVideoView()
}
