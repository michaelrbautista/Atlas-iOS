//
//  SearchTeamCell.swift
//  Atlas
//
//  Created by Michael Bautista on 10/8/24.
//

import SwiftUI

struct SearchTeamCell: View {
    
    var team: Team
    
    var body: some View {
        HStack {
            if team.imageUrl != nil {
                AsyncImage(url: URL(string: team.imageUrl!)) { image in
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
                Text(team.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(Color.ColorSystem.primaryText)
                    .font(Font.FontStyles.headline)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                
                if team.description != nil {
                    Text(team.description!)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(Color.ColorSystem.systemGray)
                        .font(Font.FontStyles.caption1)
                        .lineLimit(2)
                }
            }
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
        }
    }
}

#Preview {
    SearchTeamCell(team: Team(id: "", createdAt: "", createdBy: "", name: "Test team", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas fringilla quam ligula. Suspendisse egestas ultrices orci, ac fermentum dolor bibendum sit amet."))
}
