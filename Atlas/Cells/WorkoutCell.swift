//
//  WorkoutCell.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI

struct WorkoutCell: View {
    
    var title: String
    var description: String
    
    var body: some View {
        VStack {
            HStack(spacing: 10) {
                VStack(spacing: 5) {
                    Text(title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(Font.FontStyles.headline)
                        .foregroundStyle(Color.ColorSystem.primaryText)
                    
                    Text(description)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(Font.FontStyles.body)
                        .foregroundStyle(Color.ColorSystem.systemGray)
                        .lineLimit(2)
                }
                
//                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color.ColorSystem.systemGray)
            }
            .padding(10)
        }
        .background(Color.ColorSystem.systemGray6)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    WorkoutCell(title: "Test Workout", description: "Lorem ipsum.")
}
