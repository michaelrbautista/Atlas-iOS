//
//  AddExerciseView.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI
import PhotosUI
import AVKit

struct AddExerciseView: View {
    // MARK: UI state
    @Environment(\.dismiss) private var dismiss
    @FocusState var keyboardIsFocused: Bool
    
    // MARK: Data
    var exerciseNumber: Int
    @State var exerciseTitle = ""
    @State var sets = ""
    @State var reps = ""
    @State var instructions = ""
    
    @State var didReturnError = false
    @State var returnedErrorMessage: String? = nil
    
    public var onExerciseAdded: ((Exercise) -> Void)
    
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
            .navigationTitle("Add Exercise")
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
                    Button("Add") {
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
                            reps: reps,
                            instructions: instructions
                        )
                        
                        onExerciseAdded(newExercise)
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
    AddExerciseView(exerciseNumber: 1, onExerciseAdded: {_ in })
}
