//
//  AddExerciseView.swift
//  Atlas
//
//  Created by Michael Bautista on 9/18/24.
//

import SwiftUI

struct AddExerciseView: View {
    
    @Environment(\.dismiss) private var dismiss
    @FocusState var keyboardIsFocused: Bool
    
    @State var presentExerciseSelector = false
    @State var presentIntensitySelector = false
    
    @StateObject var viewModel = AddExerciseViewModel()
    
    var body: some View {
        List {
            Section {
                Button {
                    presentExerciseSelector.toggle()
                } label: {
                    HStack {
                        if viewModel.exercise == "" {
                            Text("Select")
                                .font(Font.FontStyles.body)
                                .foregroundStyle(Color.ColorSystem.systemGray)
                        } else {
                            Text(viewModel.exercise)
                                .font(Font.FontStyles.body)
                                .foregroundStyle(Color.ColorSystem.primaryText)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundStyle(Color.ColorSystem.systemGray)
                    }
                }
                .listRowBackground(Color.ColorSystem.systemGray6)
            } header: {
                Text("Exercise")
            }
            
            Section {
                TextField("", text: $viewModel.duration, axis: .vertical)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.numberPad)
                    .foregroundStyle(Color.ColorSystem.primaryText)
                    .listRowBackground(Color.ColorSystem.systemGray6)
            } header: {
                Text("Duration (minutes)")
            }
            
            Section {
                Button {
                    presentIntensitySelector.toggle()
                } label: {
                    HStack {
                        if viewModel.intensity == "" {
                            Text("Select")
                                .font(Font.FontStyles.body)
                                .foregroundStyle(Color.ColorSystem.systemGray)
                        } else {
                            Text(viewModel.intensity)
                                .font(Font.FontStyles.body)
                                .foregroundStyle(Color.ColorSystem.primaryText)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundStyle(Color.ColorSystem.systemGray)
                    }
                }
                .listRowBackground(Color.ColorSystem.systemGray6)
            } header: {
                Text("Intensity")
            }
            
            Section {
                Button(action: {
                    keyboardIsFocused = false
                    
                    
                    
                    dismiss()
                }, label: {
                    HStack {
                        Spacer()
                        
                        Text("Add exercise")
                            .font(Font.FontStyles.headline)
                        
                        Spacer()
                    }
                })
                .foregroundStyle(Color.ColorSystem.primaryText)
                .listRowBackground(Color.ColorSystem.systemBlue)
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .scrollDismissesKeyboard(.interactively)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Login")
        .background(Color.ColorSystem.systemBackground)
        .alert(isPresented: $viewModel.returnedError, content: {
            Alert(title: Text(viewModel.errorMessage))
        })
        .sheet(isPresented: $presentExerciseSelector) {
            DropdownView(options: [
                "Running",
                "Weightlifting",
                "Cycling",
                "Soccer",
                "Basketball",
                "Football",
                "Baseball",
                "Swimming",
                "Tennis",
                "Golf",
                "Wrestling",
                "Volleyball"
            ]) { option in
                viewModel.exercise = option
            }
        }
        .sheet(isPresented: $presentIntensitySelector) {
            DropdownView(options: [
                "Low",
                "Moderate",
                "Hard",
                "Very hard",
                "Maximal"
            ]) { option in
                viewModel.intensity = option
            }
        }
    }
}

#Preview {
    AddExerciseView()
}
