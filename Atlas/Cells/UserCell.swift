//
//  UserCell.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI

struct UserCell: View {
    
    var userImageUrl: String
    var userFullName: String
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: userImageUrl)) { image in
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
            
            Text(userFullName)
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
    UserCell(userImageUrl: "https://firebasestorage.googleapis.com:443/v0/b/stayhard-9ef02.appspot.com/o/userImages%2F7VNj6cg8u7Ndo8JwG5KevruLpEh18210374283593336603.jpg?alt=media&token=5bbe5f03-b02a-4a33-8c22-a10acfa3e739", userFullName: "Test")
}
