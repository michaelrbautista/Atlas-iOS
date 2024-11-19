//
//  SearchProgramCell.swift
//  Atlas
//
//  Created by Michael Bautista on 10/8/24.
//

import SwiftUI

struct SearchProgramCell: View {
    
    var program: Program
    
    var body: some View {
        HStack {
            if program.imageUrl != nil {
                AsyncImage(url: URL(string: program.imageUrl!)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 70, height: 40)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 5))
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
                        .frame(height: 15)
                        .foregroundStyle(Color.ColorSystem.systemGray)
                    Spacer()
                }
                .frame(width: 70, height: 40)
                .background(Color.ColorSystem.systemGray5)
                .clipShape(RoundedRectangle(cornerRadius: 5))
            }
            
            VStack {
                Text(program.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(Color.ColorSystem.primaryText)
                    .font(Font.FontStyles.headline)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                
                if program.description != nil {
                    Text(program.description!)
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
    SearchProgramCell(program: Program(id: "", createdAt: "", createdBy: "", title: "Test Program", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas fringilla quam ligula. Suspendisse egestas ultrices orci, ac fermentum dolor bibendum sit amet.", free: false, price: 20, currency: "usd", weeks: 10))
}
