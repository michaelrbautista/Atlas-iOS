//
//  SearchUserCell.swift
//  Atlas
//
//  Created by Michael Bautista on 10/8/24.
//

import SwiftUI

struct SearchUserCell: View {
    
    var user: User
    
    var body: some View {
        HStack {
            if user.profilePictureUrl != nil {
                AsyncImage(url: URL(string: user.profilePictureUrl!)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipped()
                        .clipShape(Circle())
                } placeholder: {
                    ProgressView()
                        .tint(Color.ColorSystem.primaryText)
                        .frame(width: 40, height: 40)
                }
            } else {
                VStack {
                    Spacer()
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 15)
                        .foregroundStyle(Color.ColorSystem.systemGray)
                    Spacer()
                }
                .frame(width: 40, height: 40)
                .background(Color.ColorSystem.systemGray5)
                .clipShape(Circle())
            }
            
            VStack {
                Text(user.fullName)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(Color.ColorSystem.primaryText)
                    .font(Font.FontStyles.headline)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                
                Text("@\(user.username)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(Color.ColorSystem.systemGray)
                    .font(Font.FontStyles.caption1)
                    .lineLimit(2)
            }
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
        }
    }
}

#Preview {
    SearchUserCell(user: User(id: "asdf", email: "asdf", fullName: "Test User", username: "testuser", paymentsEnabled: false))
}
