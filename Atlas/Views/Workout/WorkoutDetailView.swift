//
//  WorkoutDetailView.swift
//  stayhard
//
//  Created by Michael Bautista on 3/20/24.
//

import SwiftUI

struct WorkoutDetailView: View {
    
    @State var workoutTitle: String
    @State var workoutDescription: String
    @State var exercises: [Exercise]
    
    var body: some View {
        List {
            // MARK: Description
            if workoutDescription != "" {
                Section {
                    Text(workoutDescription)
                        .listRowBackground(Color.ColorSystem.systemGray4)
                } header: {
                    Text(workoutTitle)
                        .font(Font.FontStyles.title1)
                }
                .headerProminence(.increased)
            } else {
                Section {
                    Text(workoutTitle)
                        .font(Font.FontStyles.title1)
                }
            }
            
            // MARK: Exercises
            Section {
                ForEach(exercises) { exercise in
                    NavigationLink {
                        ExerciseDetailView(
                            exerciseTitle: exercise.title,
                            sets: exercise.sets,
                            reps: exercise.reps,
                            instructions: exercise.instructions ?? ""
                        )
                    } label: {
                        ExerciseCell(
                            exerciseNumber: exercise.id,
                            exerciseTitle: exercise.title,
                            sets: exercise.sets,
                            reps: exercise.reps
                        )
                    }
                    .listRowBackground(Color.ColorSystem.systemGray4)
                }
            } header: {
                Text("Exercises")
                    .foregroundStyle(Color.ColorSystem.primaryText)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            .headerProminence(.increased)
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.ColorSystem.systemGray5)
    }
}

#Preview {
    NavigationStack {
        WorkoutDetailView(
            workoutTitle: "Test Workout Test Workout Test Worout",
            workoutDescription: "",
            exercises: [Exercise(id: 0, title: "Test", sets: "1", reps: "1")]
        )
    }
}
