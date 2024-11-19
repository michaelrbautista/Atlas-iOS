//
//  TeamCell.swift
//  Atlas
//
//  Created by Michael Bautista on 9/8/24.
//

import SwiftUI

struct TeamCell: View {
    
    @State var isLoading = true
    
    var teamId: String
    
    @State var team: Team? = nil
    
    var body: some View {
        if isLoading || team == nil {
            VStack {
                HStack {
                    ProgressView()
                        .frame(width: 80, height: 80)
                        .background(Color.ColorSystem.systemGray5)
                        .clipShape(Circle())
                        .tint(Color.ColorSystem.primaryText)
                    
                    VStack(alignment: .leading) {
                        Text("")
                            .font(Font.FontStyles.title3)
                            .foregroundStyle(Color.ColorSystem.primaryText)
                            .lineLimit(1)
                        
                        Text("")
                            .font(Font.FontStyles.headline)
                            .foregroundStyle(Color.ColorSystem.systemGray)
                            .lineLimit(2)
                    }
                    
                    Spacer()
                }
            }
            .padding(20)
            .background(Color.ColorSystem.systemGray6)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .task {
                do {
                    let team = try await TeamService.shared.getTeam(teamId: teamId)
                    
                    self.team = team
                    
                    isLoading = false
                } catch {
                    print(error)
                }
            }
        } else {
            VStack {
                HStack(alignment: .center, spacing: 16) {
                    if team!.imageUrl != nil {
                        AsyncImage(url: URL(string: team!.imageUrl!)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                        } placeholder: {
                            ProgressView()
                                .frame(width: 80, height: 80)
                                .background(Color.ColorSystem.systemGray5)
                                .clipShape(Circle())
                                .tint(Color.ColorSystem.primaryText)
                        }
                    } else {
                        VStack {
                            Image(systemName: "person.circle.fill")
                                .foregroundStyle(Color.ColorSystem.systemGray)
                        }
                        .frame(width: 80, height: 80)
                        .background(Color.ColorSystem.systemGray6)
                        .clipShape(Circle())
                    }
                    
                    VStack(alignment: .leading) {
                        Text(team!.name)
                            .font(Font.FontStyles.title3)
                            .foregroundStyle(Color.ColorSystem.primaryText)
                            .lineLimit(1)
                        
                        Text(team!.description ?? "")
                            .font(Font.FontStyles.headline)
                            .foregroundStyle(Color.ColorSystem.systemGray)
                            .lineLimit(2)
                    }
                    
                    Spacer()
                }
            }
            .padding(20)
            .background(Color.ColorSystem.systemGray6)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

#Preview {
    TeamCell(teamId: "cd44e7f8-c584-4af3-abd2-870aa3fbc1be")
}
