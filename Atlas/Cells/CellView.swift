//
//  CellView.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI

struct CellView: View {
    
    var imageUrl: String
    var title: String
    var creator: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            AsyncImage(url: URL(string: imageUrl)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: ((UIScreen.main.bounds.size.width - 48) / 2), height: ((UIScreen.main.bounds.size.width - 48) / 2))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } placeholder: {
                ProgressView()
                    .frame(width: ((UIScreen.main.bounds.size.width - 48) / 2), height: ((UIScreen.main.bounds.size.width - 48) / 2))
                    .tint(Color.ColorSystem.primaryText)
            }
            
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
                .foregroundStyle(Color.ColorSystem.primaryText)
                .font(Font.FontStyles.headline)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
            
            Text(creator)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(Color.ColorSystem.secondaryText)
                .font(Font.FontStyles.subhead)
            
            Spacer()
        }
        .background(Color.ColorSystem.systemGray5)
    }
}

#Preview {
    CellView(imageUrl: "https://firebasestorage.googleapis.com:443/v0/b/stayhard-9ef02.appspot.com/o/programImages%2Fnm8axxxzFZZO8B3qM1Fg34cNxTE3-7763174990326985035.jpg?alt=media&token=d599652a-5599-486f-9141-fa0e209ca2b8", title: "Test", creator: "Test")
}
