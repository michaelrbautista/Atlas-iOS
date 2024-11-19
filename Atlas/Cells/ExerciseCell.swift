//
//  ExerciseCell.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI

struct ExerciseCell: View {
    
    var exerciseId: String
    var exerciseNumber: Int
    var sets: Int
    var reps: Int
    
    @State var isLoading = true
    @State var exercise: Exercise? = nil
    
    var body: some View {
        if isLoading || exercise == nil {
            VStack(alignment: .center) {
                Spacer()
                ProgressView()
                    .frame(maxWidth: UIScreen.main.bounds.size.width)
                    .tint(Color.ColorSystem.primaryText)
                Spacer()
            }
            .background(Color.ColorSystem.systemGray5)
            .navigationBarTitleDisplayMode(.inline)
            .task {
                do {
                    let exercse = try await ExerciseService.shared.getExercise(exerciseId: exerciseId)
                    
                    self.exercise = exercse
                    
                    isLoading = false
                } catch {
                    print(error)
                }
            }
        } else {
            HStack(alignment: .top, spacing: 4) {
                Text("\(exerciseNumber).")
                    .frame(alignment: .topLeading)
                    .font(Font.FontStyles.headline)
                    .foregroundStyle(Color.ColorSystem.primaryText)
                
                VStack(spacing: 4) {
                    Text("\(exercise!.title)")
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
}

#Preview {
    ExerciseCell(exerciseId: "", exerciseNumber: 1, sets: 1, reps: 1)
}
