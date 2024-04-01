//
//  EditWorkoutView.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI

struct EditWorkoutView: View {
    // MARK: UI state
    @Environment(\.dismiss) private var dismiss
    @State private var addExerciseIsPresented = false
    @FocusState var keyboardIsFocused: Bool
    
    // MARK: Data
    @State var workoutNumber: Int
    
    @State var workoutTitle: String
    @State var exercises: [Exercise]
    
    @State private var exerciseSelected: Exercise? = nil
    
    public var onWorkoutSaved: ((Workout) -> Void)
    
    var body: some View {
        NavigationStack {
            List {
                // MARK: Text Field
                Section {
                    TextField(text: $workoutTitle, prompt: Text("Workout Title")) {
                        Text("Workout Title")
                    }
                    .foregroundStyle(Color.ColorSystem.primaryText)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.ColorSystem.systemGray3)
                }
                
                // MARK: Workouts
                Section {
                    ForEach(exercises) { exercise in
                        ExerciseCell(
                            exerciseNumber: exercise.id,
                            exerciseTitle: exercise.title,
                            sets: exercise.sets,
                            reps: exercise.reps
                        )
                        .listRowBackground(Color.ColorSystem.systemGray3)
                    }
                    
                    Button(action: {
                        keyboardIsFocused = false
                        addExerciseIsPresented.toggle()
                    }, label: {
                        HStack {
                            Text("Add exercise")
                                .foregroundStyle(Color.ColorSystem.systemBlue)
                            Spacer()
                        }
                    })
                    .listRowBackground(Color.ColorSystem.systemGray3)
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
            .navigationTitle("Add Workout")
            .background(Color.ColorSystem.systemGray5)
            .sheet(isPresented: $addExerciseIsPresented, content: {
                AddExerciseView(exerciseNumber: exercises.count) { exercise in
                    exercises.insert(exercise, at: exercise.id)
                }
            })
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        keyboardIsFocused = false
                        
                        let newWorkout = Workout(
                            id: workoutNumber,
                            title: workoutTitle,
                            exercises: exercises
                        )
                        
                        onWorkoutSaved(newWorkout)
                        dismiss()
                    }
                    .tint(Color.ColorSystem.systemBlue)
                }
            })
        }
    }
}

#Preview {
    EditWorkoutView(
        workoutNumber: 1,
        workoutTitle: "Test Workout",
        exercises: [Exercise(id: 1, title: "Test Exercise", sets: 2, reps: 2)],
        onWorkoutSaved: {_ in}
    )
}
