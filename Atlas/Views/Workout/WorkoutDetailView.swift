//
//  WorkoutDetailView.swift
//  stayhard
//
//  Created by Michael Bautista on 3/20/24.
//

import SwiftUI

struct WorkoutDetailView: View {
    @EnvironmentObject var viewModel: ProgramDetailViewModel
    
    // MARK: Workout data
    @State var workout: Workout
    
    var body: some View {
        List {
            // MARK: Description
            if workout.description != "" {
                Section {
                    Text(workout.description)
                        .listRowBackground(Color.ColorSystem.systemGray4)
                } header: {
                    Text(workout.title)
                        .font(Font.FontStyles.title1)
                }
                .headerProminence(.increased)
            } else {
                Section {
                    Text(workout.title)
                        .font(Font.FontStyles.title1)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
            }
            
            // MARK: Exercises
            Section {
//                ForEach(workout.exercises) { exercise in
//                    NavigationLink {
//                        ExerciseDetailView(workoutId: workout.id, exercise: exercise)
//                            .environmentObject(viewModel)
//                    } label: {
//                        ExerciseCell(
//                            exerciseNumber: exercise.id,
//                            exerciseTitle: exercise.title,
//                            sets: exercise.sets,
//                            reps: exercise.reps
//                        )
//                    }
//                    .listRowBackground(Color.ColorSystem.systemGray4)
//                }
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
    WorkoutDetailView(workout: Workout(id: "", workout_number: 2, title: "Test", description: "Description"))
        .environmentObject(ProgramDetailViewModel(savedProgram: SavedProgram(program_id: "", saved_by: "", created_by: "")))
}
