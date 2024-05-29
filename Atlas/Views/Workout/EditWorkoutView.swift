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
    @State private var editExerciseIsPresented = false
    @FocusState var keyboardIsFocused: Bool
    
    // MARK: Data
    @State var workoutId: Int
    
    @State var workoutTitle: String
    @State var workoutDescription: String
    @State var exercises: [Exercise]
    
    @State var didReturnError = false
    @State var returnedErrorMessage: String? = nil
    
    @State private var exerciseSelected: Exercise? = nil
    
    public var onWorkoutSaved: ((Workout) -> Void)
    
    var body: some View {
        NavigationStack {
            List {
                // MARK: Text Field
                Section {
                    TextField(text: $workoutTitle, prompt: Text("Workout Title")) {
                        Text("Title")
                    }
                    .foregroundStyle(Color.ColorSystem.primaryText)
                    .listRowBackground(Color.ColorSystem.systemGray4)
                } header: {
                    Text("Title")
                }
                
                Section {
                    NavigationLink {
                        TextFieldView(textEntered: $workoutDescription)
                    } label: {
                        HStack() {
                            if workoutDescription == "" {
                                Text("Add description...")
                                    .foregroundStyle(Color.ColorSystem.systemGray1)
                            } else {
                                Text(workoutDescription)
                                    .foregroundStyle(Color.ColorSystem.primaryText)
                                    .lineLimit(1)
                            }
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .listRowBackground(Color.ColorSystem.systemGray4)
                } header: {
                    Text("Description")
                }
                
                // MARK: Exercises
                Section {
                    ForEach(exercises) { exercise in
//                        ExerciseCell(
//                            exerciseNumber: exercise.id,
//                            exerciseTitle: exercise.title,
//                            sets: exercise.sets,
//                            reps: exercise.reps
//                        )
//                        .background(Color.ColorSystem.systemGray4)
//                        .listRowBackground(Color.ColorSystem.systemGray4)
//                        .deleteDisabled(exercise.video_url != nil)
//                        .onTapGesture {
//                            exerciseSelected = exercise
//                            editExerciseIsPresented.toggle()
//                        }
                    }
//                    .onDelete(perform: { indexSet in
//                        self.exercises.remove(atOffsets: indexSet)
//                    })
                    
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
                    .listRowBackground(Color.ColorSystem.systemGray4)
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
            .navigationTitle("Edit Workout")
            .background(Color.ColorSystem.systemGray5)
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Text("Cancel")
                    })
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
//                        keyboardIsFocused = false
//                        
//                        if workoutTitle == "" {
//                            didReturnError = true
//                            returnedErrorMessage = "Please enter a title."
//                            return
//                        }
//                        
//                        let newWorkout = Workout(
//                            id: workoutId,
//                            title: workoutTitle,
//                            description: "",
//                            exercises: exercises
//                        )
//                        
//                        onWorkoutSaved(newWorkout)
//                        dismiss()
                    }
                    .tint(Color.ColorSystem.systemBlue)
                }
            })
            .alert(isPresented: $didReturnError, content: {
                Alert(title: Text(returnedErrorMessage ?? "Couldn't add workout."))
            })
            .sheet(isPresented: $addExerciseIsPresented, content: {
//                AddExerciseView(exerciseId: exercises.count) { exercise  in
//                    exercises.insert(exercise, at: exercise.id)
//                }
            })
            .sheet(isPresented: $editExerciseIsPresented, content: {
//                if exerciseSelected != nil {
//                    EditExerciseView(
//                        workoutId: workoutId,
//                        exerciseId: exerciseSelected!.id,
//                        exerciseTitle: exerciseSelected!.title,
//                        sets: exerciseSelected!.sets,
//                        reps: exerciseSelected!.reps,
//                        instructions: exerciseSelected!.instructions) { exercise in
//                            self.exercises[exercise.id] = exercise
//                        }
//                }
            })
        }
    }
}

#Preview {
    EditWorkoutView(
        workoutId: 1,
        workoutTitle: "Test Workout",
        workoutDescription: "",
        exercises: [],
        onWorkoutSaved: {_ in}
    )
}
