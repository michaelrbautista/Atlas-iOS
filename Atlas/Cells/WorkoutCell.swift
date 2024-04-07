//
//  WorkoutCell.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI

struct WorkoutCell: View {
    
    var workoutTitle: String
    
    var body: some View {
        Text(workoutTitle)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(Font.FontStyles.body)
            .foregroundStyle(Color.ColorSystem.primaryText)
    }
}

#Preview {
    WorkoutCell(workoutTitle: "Test Workout")
}
