//
//  EditExerciseView.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI

struct EditExerciseView: View {
    
    // MARK: UI state
    @Environment(\.dismiss) private var dismiss
    @FocusState var keyboardIsFocused: Bool
    
    // MARK: Data
    var exerciseNumber: Int
    @State var exerciseTitle: String
    @State var sets: String
    @State var reps: String
    @State var instructions: String
    
    @State var didReturnError = false
    @State var returnedErrorMessage: String? = nil
    
    public var onExerciseSaved: ((Exercise) -> Void)
    
    var body: some View {
        NavigationStack {
            List {
                // MARK: Text Field
                Section {
                    TextField(text: $exerciseTitle, prompt: Text("Title")) {
                        Text("Title")
                    }
                    .foregroundStyle(Color.ColorSystem.primaryText)
                    .listRowBackground(Color.ColorSystem.systemGray4)
                } header: {
                    Text("Title")
                }
                
                Section {
                    TextField(text: $sets, prompt: Text("Sets")) {
                        Text("Sets")
                    }
                    .foregroundStyle(Color.ColorSystem.primaryText)
                    .listRowBackground(Color.ColorSystem.systemGray4)
                } header: {
                    Text("Sets")
                }
                
                Section {
                    TextField(text: $reps, prompt: Text("Reps")) {
                        Text("Reps")
                    }
                    .foregroundStyle(Color.ColorSystem.primaryText)
                    .listRowBackground(Color.ColorSystem.systemGray4)
                } header: {
                    Text("Reps")
                }
                
                // MARK: Text Field
                Section {
                    TextField("", text: $instructions, prompt: instructions == "" ? Text("Add instructions...") : Text(""), axis: .vertical)
                        .lineLimit(16...)
                    .listRowBackground(Color.ColorSystem.systemGray4)
                } header: {
                    Text("Instructions")
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Edit Exercise")
            .background(Color.ColorSystem.systemGray5)
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        keyboardIsFocused = false
                        dismiss()
                    }
                    .tint(Color.ColorSystem.primaryText)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        keyboardIsFocused = false
                        
                        if exerciseTitle == "" {
                            didReturnError = true
                            returnedErrorMessage = "Please enter a title."
                            return
                        }
                        
                        let newExercise = Exercise(
                            id: exerciseNumber,
                            title: exerciseTitle,
                            sets: sets,
                            reps: reps
                        )
                        
                        onExerciseSaved(newExercise)
                        dismiss()
                    }
                    .tint(Color.ColorSystem.systemBlue)
                }
            })
            .alert(isPresented: $didReturnError, content: {
                Alert(title: Text(returnedErrorMessage ?? "Couldn't add exercise."))
            })
        }
    }
}

#Preview {
    EditExerciseView(exerciseNumber: 1, exerciseTitle: "Test", sets: "2", reps: "3", instructions: "", onExerciseSaved: {_ in})
}
