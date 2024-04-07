//
//  ExerciseDetailView.swift
//  stayhard
//
//  Created by Michael Bautista on 3/31/24.
//

import SwiftUI

struct ExerciseDetailView: View {
    
    @State var exerciseTitle: String
    @State var sets: String
    @State var reps: String
    @State var instructions: String
    
    var body: some View {
        List {
            // MARK: Name
            Section {
                Text(sets == "1" ? "\(sets) set" : "\(sets) sets")
                    .font(Font.FontStyles.body)
                    .foregroundStyle(Color.ColorSystem.primaryText)
                    .listRowBackground(Color.ColorSystem.systemGray4)
                
                Text(reps == "1" ? "\(reps) rep" : "\(reps) reps")
                    .font(Font.FontStyles.body)
                    .foregroundStyle(Color.ColorSystem.primaryText)
                    .listRowBackground(Color.ColorSystem.systemGray4)
            } header: {
                Text(exerciseTitle)
                    .font(Font.FontStyles.title1)
            }
            .headerProminence(.increased)
            
            if instructions != "" {
                Section {
                    Text(instructions)
                        .font(Font.FontStyles.body)
                        .foregroundStyle(Color.ColorSystem.primaryText)
                        .listRowBackground(Color.ColorSystem.systemGray4)
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.ColorSystem.systemGray5)
    }
}

#Preview {
    ExerciseDetailView(exerciseTitle: "Test exercise", sets: "1-3", reps: "1", instructions: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas fringilla quam ligula. Suspendisse egestas ultrices orci, ac fermentum dolor bibendum sit amet. Vestibulum blandit, magna ullamcorper volutpat condimentum, nulla elit lacinia odio, at accumsan urna enim non diam. In in lacus urna.")
}
