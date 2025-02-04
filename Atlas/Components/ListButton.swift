//
//  ListButton.swift
//  Atlas
//
//  Created by Michael Bautista on 1/29/25.
//

import SwiftUI

struct ListButton: View {
    
    var text: String
    var textColor: Color
    var buttonColor: Color
    
    var body: some View {
        Button {
            
        } label: {
            HStack {
                Spacer()
                Text(text)
                    .font(Font.FontStyles.headline)
                    .foregroundStyle(textColor)
                Spacer()
            }
            .padding(10)
            .background(buttonColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
        .listRowSeparator(.hidden)
    }
}

#Preview {
    ListButton(text: "Test", textColor: Color.ColorSystem.systemBlue, buttonColor: Color.ColorSystem.primaryText)
}
