//
//  UserCell.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI

struct UserCell: View {
    
    var user: User
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            if user.profilePictureUrl != nil {
                AsyncImage(url: URL(string: user.profilePictureUrl!)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                } placeholder: {
                    ProgressView()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .tint(Color.ColorSystem.primaryText)
                }
            } else {
                VStack {
                    Image(systemName: "person.circle.fill")
                        .foregroundStyle(Color.ColorSystem.systemGray)
                }
                .frame(width: 80, height: 80)
                .background(Color.ColorSystem.systemGray4)
                .clipShape(Circle())
            }
            
            VStack(alignment: .leading) {
                Text(user.fullName)
                    .font(Font.FontStyles.title3)
                    .foregroundStyle(Color.ColorSystem.primaryText)
                    .lineLimit(1)
                
                Text("@\(user.username)")
                    .font(Font.FontStyles.headline)
                    .foregroundStyle(Color.ColorSystem.systemGray)
                    .lineLimit(1)
            }
            
            Spacer()
        }
        .background(Color.ColorSystem.systemGray5)
        .padding(0)
    }
}

#Preview {
    UserCell(user: User(id: "", createdAt: "", email: "testuser@email.com", fullName: "Test", username: "testuser", bio: "Test", paymentsEnabled: false))
}
