//
//  WorkoutCell.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI

struct WorkoutCell: View {
    
    var title: String
    var description: String?
    
    var body: some View {
        VStack(spacing: 5) {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(Font.FontStyles.headline)
                .foregroundStyle(Color.ColorSystem.primaryText)
            
            if description != nil {
                Text(description!)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(Font.FontStyles.body)
                    .foregroundStyle(Color.ColorSystem.systemGray)
                    .lineLimit(2)
            }
        }
    }
}

#Preview {
    WorkoutCell(title: "Test Workout", description: "Lorem ipsum.")
}
