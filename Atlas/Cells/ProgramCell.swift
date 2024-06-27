//
//  ProgramCell.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI

struct ProgramCell: View {
    
    @State var isLoading = true
    
    var programId: String
    
    @State var program: Program? = nil
    @State var user: User? = nil
    
    var body: some View {
        if isLoading || program == nil || user == nil {
            Color.ColorSystem.systemGray5
            .task {
                do {
                    let program = try await ProgramService.shared.getProgram(programId: programId)
                    
                    self.program = program
                    
                    let user = try await UserService.shared.getUser(uid: program.createdBy)
                    
                    self.user = user
                    
                    isLoading = false
                } catch {
                    print(error)
                }
            }
        } else {
            VStack(alignment: .leading, spacing: 0) {
                if program!.imageUrl != nil {
                    AsyncImage(url: URL(string: program!.imageUrl!)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .frame(height: ((UIScreen.main.bounds.size.width - 32) / 2))
                            .clipped()
                    } placeholder: {
                        ProgressView()
                            .tint(Color.ColorSystem.primaryText)
                            .frame(maxWidth: .infinity)
                            .frame(height: ((UIScreen.main.bounds.size.width - 32) / 2))
                    }
                } else {
                    VStack {
                        Spacer()
                        Image(systemName: "figure.run")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 48)
                            .foregroundStyle(Color.ColorSystem.secondaryText)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 180)
                    .background(Color.ColorSystem.systemGray4)
                }
                
                VStack {
                    Text(program!.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(Color.ColorSystem.primaryText)
                        .font(Font.FontStyles.title2)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                    
                    Text("@\(user!.username)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(Color.ColorSystem.secondaryText)
                        .font(Font.FontStyles.headline)
                }
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            }
            .background(Color.ColorSystem.systemGray4)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

#Preview {
    ProgramCell(programId: "a4f83733-5cc4-444a-b732-b6dfcdbc7f55")
}
