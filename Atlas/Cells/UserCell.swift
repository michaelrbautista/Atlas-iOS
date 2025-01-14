//
//  UserCell.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI

struct UserCell: View {
    
    var profilePictureUrl: String?
    var fullName: String
    var username: String
    var bio: String?
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            if profilePictureUrl != nil {
                AsyncImage(url: URL(string: profilePictureUrl!)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                } placeholder: {
                    ProgressView()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .tint(Color.ColorSystem.primaryText)
                }
            } else {
                VStack {
                    Image(systemName: "person.circle.fill")
                        .foregroundStyle(Color.ColorSystem.systemGray)
                }
                .frame(width: 50, height: 50)
                .background(Color.ColorSystem.systemGray4)
                .clipShape(Circle())
            }
            
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading) {
                    Text(fullName)
                        .font(Font.FontStyles.headline)
                        .foregroundStyle(Color.ColorSystem.primaryText)
                        .lineLimit(1)
                    
                    Text("@\(username)")
                        .font(Font.FontStyles.body)
                        .foregroundStyle(Color.ColorSystem.systemGray)
                        .lineLimit(1)
                }
                
                if let bio = bio {
                    Text(bio)
                        .font(Font.FontStyles.subhead)
                        .foregroundStyle(Color.ColorSystem.systemGray)
                        .lineLimit(2)
                }
            }
        }
        .padding(0)
    }
}

#Preview {
    UserCell(fullName: "Test user", username: "testuser", bio: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas fringilla quam ligula. Suspendisse egestas ultrices orci, ac fermentum dolor bibendum sit amet.")
}
