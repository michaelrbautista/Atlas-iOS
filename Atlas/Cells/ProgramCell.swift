//
//  ProgramCell.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI

struct ProgramCell: View {
    
    var title: String
    var imageUrl: String?
    var userFullName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if imageUrl != nil {
                AsyncImage(url: URL(string: imageUrl!)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: UIScreen.main.bounds.size.width - 32)
                        .frame(height: 180)
                        .clipped()
                } placeholder: {
                    ProgressView()
                        .tint(Color.ColorSystem.primaryText)
                        .frame(maxWidth: UIScreen.main.bounds.size.width - 32)
                        .frame(height: 180)
                }
            } else {
                VStack {
                    Spacer()
                    Image(systemName: "figure.run")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 48)
                        .foregroundStyle(Color.ColorSystem.systemGray)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .frame(height: 180)
                .background(Color.ColorSystem.systemGray5)
            }
            
            VStack {
                Text(title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(Color.ColorSystem.primaryText)
                    .font(Font.FontStyles.title2)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                
                Text(userFullName)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(Color.ColorSystem.systemGray)
                    .font(Font.FontStyles.headline)
            }
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
        }
        .background(Color.ColorSystem.systemGray6)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    ProgramCell(title: "Test", userFullName: "Test User")
}
