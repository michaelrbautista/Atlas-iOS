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
    
    public var onExerciseSaved: ((Exercise) -> Void)
    
    var body: some View {
        NavigationStack {
            List {
                // MARK: Text Field
                Section {
                    TextField(text: $exerciseTitle, prompt: Text("Exercise Title")) {
                        Text("Exercise Title")
                    }
                    .background(Color.ColorSystem.systemGray3)
                    .foregroundStyle(Color.ColorSystem.primaryText)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.ColorSystem.systemGray3)
                    
                    TextField(text: $sets, prompt: Text("Sets")) {
                        Text("Sets")
                    }
                    .background(Color.ColorSystem.systemGray3)
                    .foregroundStyle(Color.ColorSystem.primaryText)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.ColorSystem.systemGray3)
                    
                    TextField(text: $reps, prompt: Text("Reps")) {
                        Text("Reps")
                    }
                    .background(Color.ColorSystem.systemGray3)
                    .foregroundStyle(Color.ColorSystem.primaryText)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.ColorSystem.systemGray3)
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
                    Button("Save") {
                        keyboardIsFocused = false
                        
                        let newExercise = Exercise(
                            id: exerciseNumber,
                            title: exerciseTitle,
                            sets: Int(sets) ?? 0,
                            reps: Int(reps) ?? 0
                        )
                        
                        onExerciseSaved(newExercise)
                        dismiss()
                    }
                    .tint(Color.ColorSystem.systemBlue)
                }
            })
        }
    }
}

#Preview {
//    EditExerciseView(exerciseNumber: 1, onExerciseSaved: {_ in })
    EmptyView()
}
