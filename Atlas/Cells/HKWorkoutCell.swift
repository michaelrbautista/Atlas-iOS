//
//  HKWorkoutCell.swift
//  Atlas
//
//  Created by Michael Bautista on 11/10/24.
//

import SwiftUI

struct HKWorkoutCell: View {
    
    var workout: HealthKitWorkout
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(workout.type)
                    .font(Font.FontStyles.headline)
                    .foregroundStyle(Color.ColorSystem.primaryText)
                
                Text(workout.date)
                    .font(Font.FontStyles.footnote)
                    .foregroundStyle(Color.ColorSystem.systemGray)
            }
            
            Spacer()
            
            Text(workout.calories + " cal")
                .font(Font.FontStyles.headline)
                .foregroundStyle(Color.ColorSystem.systemGray)
        }
        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
        .background(Color.ColorSystem.systemGray6)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    HKWorkoutCell(workout: HealthKitWorkout(type: "Run", date: "Nov 10, 2024", calories: "500"))
}
