//
//  ExerciseCell.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI

struct ExerciseCell: View {
    
    var exerciseNumber: Int?
    var name: String
    var sets: Int
    var reps: Int
    
    var body: some View {
        HStack(alignment: .top, spacing: 4) {
            if let exerciseNumber = exerciseNumber {
                Text("\(exerciseNumber).")
                    .frame(alignment: .topLeading)
                    .font(Font.FontStyles.headline)
                    .foregroundStyle(Color.ColorSystem.primaryText)
            }
            
            VStack(spacing: 4) {
                Text(name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(Font.FontStyles.headline)
                    .foregroundStyle(Color.ColorSystem.primaryText)
                
                Text("\(sets) \(sets == 1 ? "set" : "sets")")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(Font.FontStyles.body)
                    .foregroundStyle(Color.ColorSystem.systemGray)
                
                Text("\(reps) \(reps == 1 ? "rep" : "reps")")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(Font.FontStyles.body)
                    .foregroundStyle(Color.ColorSystem.systemGray)
            }
            
            Spacer()
        }
        .padding(0)
    }
}

#Preview {
    ExerciseCell(exerciseNumber: 1, name: "Test", sets: 1, reps: 1)
}
