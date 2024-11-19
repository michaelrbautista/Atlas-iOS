//
//  VideoCellFromData.swift
//  Atlas
//
//  Created by Michael Bautista on 6/22/24.
//

import SwiftUI
import AVFoundation

struct VideoCellFromData: View {
    
    var videoData: Data
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
                    .background(Color.ColorSystem.systemGray5)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .onAppear(perform: {
                        DispatchQueue.global().async {
                            let directory = NSTemporaryDirectory()
                            let fileName = "\(NSUUID().uuidString).mov"
                            let fullURL = NSURL.fileURL(withPathComponents: [directory, fileName])
                            try! videoData.write(to: fullURL!)
                            let asset = AVAsset(url: fullURL!)
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
                    })
            }
            Spacer()
        }
    }
}

#Preview {
    VideoCellFromData(videoData: Data(), onPlay: {})
}
