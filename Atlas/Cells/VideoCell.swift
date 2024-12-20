//
//  VideoCell.swift
//  Atlas
//
//  Created by Michael Bautista on 6/19/24.
//

import SwiftUI
import AVFoundation

struct VideoCell: View {
    
    var videoUrl: URL
    @State var thumbnail: UIImage? = nil
    
    var onPlay: (() -> Void)
    
    var body: some View {
        HStack {
            Spacer()
            if let thumbnailImage = thumbnail {
                ZStack {
                    Image(uiImage: thumbnailImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 160, height: 200)
                        .opacity(0.6)
                    
                    Button(action: {
                        onPlay()
                    }, label: {
                        Image(systemName: "play.fill")
                            .foregroundStyle(Color.ColorSystem.primaryText)
                            .font(Font.FontStyles.title2)
                    })
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                ProgressView()
                    .frame(width: 160, height: 200)
                    .tint(Color.ColorSystem.primaryText)
                    .background(Color.ColorSystem.systemGray6)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .onAppear {
                        DispatchQueue.global().async {
                            let asset = AVAsset(url: videoUrl)
                            let imageGenerator = AVAssetImageGenerator(asset: asset)
                            let time = CMTime(value: 0, timescale: 60)
                            let times = [NSValue(time: time)]
                            imageGenerator.generateCGImagesAsynchronously(forTimes: times) { _, image, _, _, _ in
                                if let image = image {
                                    self.thumbnail = UIImage(cgImage: image)
                                } else {
                                    print("Couldn't get video thumbnail")
                                }
                            }
                        }
                    }
            }
            Spacer()
        }
    }
}

#Preview {
    VideoCell(videoUrl: URL(string: "https://ltjnvfgpomlatmtqjxrk.supabase.co/storage/v1/object/public/exercise_videos/640b0902-fec9-449b-aead-8e226c7682db-965909189293864553.mp4?t=2024-06-20T01%3A33%3A11.186Z")!, onPlay: {})
}
