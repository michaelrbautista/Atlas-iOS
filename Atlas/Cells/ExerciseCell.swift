//
//  ExerciseCell.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI

struct ExerciseCell: View {
    
    var exerciseNumber: Int
    var exerciseTitle: String
    var sets: String
    var reps: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 4) {
            Text("\(exerciseNumber + 1).")
                .frame(alignment: .topLeading)
                .font(Font.FontStyles.headline)
                .foregroundStyle(Color.ColorSystem.primaryText)
            
            VStack(spacing: 4) {
                Text("\(exerciseTitle)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(Font.FontStyles.headline)
                    .foregroundStyle(Color.ColorSystem.primaryText)
                
                Text("\(sets) \(sets == "1" ? "set" : "sets")")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(Font.FontStyles.body)
                    .foregroundStyle(Color.ColorSystem.secondaryText)
                
                Text("\(reps) \(reps == "1" ? "rep" : "reps")")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(Font.FontStyles.body)
                    .foregroundStyle(Color.ColorSystem.secondaryText)
            }
            
            Spacer()
        }
        .padding(0)
    }
}

#Preview {
    ExerciseCell(exerciseNumber: 1, exerciseTitle: "Test", sets: "1", reps: "1")
}
