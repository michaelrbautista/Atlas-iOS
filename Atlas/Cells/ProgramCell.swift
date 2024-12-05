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
        HStack(spacing: 10) {
            if imageUrl != nil {
                AsyncImage(url: URL(string: imageUrl!)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .clipped()
                } placeholder: {
                    ProgressView()
                        .tint(Color.ColorSystem.primaryText)
                        .frame(width: 100, height: 100)
                }
            } else {
                VStack {
                    Spacer()
                    Image(systemName: "figure.run")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 32)
                        .foregroundStyle(Color.ColorSystem.systemGray)
                    Spacer()
                }
                .frame(width: 100, height: 100)
                .background(Color.ColorSystem.systemGray6)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .clipped()
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
                
                
                
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 100)
    }
}

#Preview {
    ProgramCell(title: "Test", userFullName: "Test User")
}
