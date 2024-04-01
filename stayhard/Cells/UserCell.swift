//
//  TeamCell.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI

struct UserCell: View {
    
    var teamImageUrl: String
    var teamName: String
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: teamImageUrl)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.size.width - 32, height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } placeholder: {
                ProgressView()
                    .frame(width: UIScreen.main.bounds.size.width - 32, height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .tint(Color.ColorSystem.primaryText)
            }
            
            Text(teamName)
                .font(Font.FontStyles.title2)
                .foregroundStyle(Color.ColorSystem.primaryText)
        }
        .background(Color.ColorSystem.systemGray5)
        .padding(0)
    }
    
    private func getImage(iamgeUrl: String) {
        
    }
}

#Preview {
    UserCell(teamImageUrl: "https://firebasestorage.googleapis.com:443/v0/b/evo-fitness-db963.appspot.com/o/profilePictures%2FH5P9e6BSoTbeXIZFkQxZGef1Xwo11903144260753282703.jpg?alt=media&token=420dad1e-3dd5-43a0-a5e4-9551f8fd3141", teamName: "Test")
}
