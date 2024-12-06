//
//  ExerciseCell.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI

struct ExerciseCell: View {
    
    var exercise: FetchedProgramExercise
    
    var body: some View {
        HStack(alignment: .top, spacing: 4) {
            Text("\(exercise.exerciseNumber).")
                .frame(alignment: .topLeading)
                .font(Font.FontStyles.headline)
                .foregroundStyle(Color.ColorSystem.primaryText)
            
            VStack(spacing: 4) {
                Text("\(exercise.exercises?.title ?? "")")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(Font.FontStyles.headline)
                    .foregroundStyle(Color.ColorSystem.primaryText)
                
                Text("\(exercise.sets ?? 1) \(exercise.sets == 1 ? "set" : "sets")")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(Font.FontStyles.body)
                    .foregroundStyle(Color.ColorSystem.systemGray)
                
                Text("\(exercise.reps ?? 1) \(exercise.reps == 1 ? "rep" : "reps")")
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
    ExerciseCell(exercise: FetchedProgramExercise(id: "1234", exerciseNumber: 0))
}
