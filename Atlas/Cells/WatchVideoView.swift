//
//  WatchVideoView.swift
//  Atlas
//
//  Created by Michael Bautista on 6/18/24.
//

import SwiftUI
import AVKit

struct WatchVideoView: View {
    @Environment(\.dismiss) private var dismiss
    var videoUrl: String
    @State private var player = AVPlayer()
    
    var body: some View {
        NavigationStack {
            VideoPlayer(player: player)
                .ignoresSafeArea(edges: .all)
                .onAppear(perform: {
                    if let url = URL(string: videoUrl) {
                        player = AVPlayer(url: url)
                        player.play()
                    }
                })
                .toolbar(content: {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            dismiss()
                        }, label: {
                            Text("Close")
                                .foregroundStyle(Color.ColorSystem.primaryText)
                        })
                    }
                })
        }
    }
}

#Preview {
    WatchVideoView(videoUrl: "https://ltjnvfgpomlatmtqjxrk.supabase.co/storage/v1/object/public/exercise_videos/640b0902-fec9-449b-aead-8e226c7682db-965909189293864553.mp4?t=2024-06-20T01%3A33%3A11.186Z")
}
