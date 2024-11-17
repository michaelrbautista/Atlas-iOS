//
//  CreateNutritionPlanView.swift
//  Atlas
//
//  Created by Michael Bautista on 9/18/24.
//

import SwiftUI

struct CreateNutritionPlanView: View {
    
    @Environment(\.dismiss) private var dismiss
    @FocusState var keyboardIsFocused: Bool
    
    @State var presentSexSelector = false
    @State var presentGoalSelector = false
    
    @StateObject var viewModel = CreateNutritionPlanViewModel()
    
    var body: some View {
        List {
            Section {
                TextField("", text: $viewModel.age, axis: .vertical)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.numberPad)
                    .foregroundStyle(Color.ColorSystem.primaryText)
                    .listRowBackground(Color.ColorSystem.systemGray6)
                    .disabled(viewModel.isLoading)
            } header: {
                Text("Age")
            }
            
            Section {
                Button {
                    presentSexSelector.toggle()
                } label: {
                    HStack {
                        if viewModel.sex == "" {
                            Text("Select")
                                .font(Font.FontStyles.body)
                                .foregroundStyle(Color.ColorSystem.systemGray)
                        } else {
                            Text(viewModel.sex)
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
                Text("Sex")
            }
            
            Section {
                TextField("", text: $viewModel.height, axis: .vertical)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.numberPad)
                    .foregroundStyle(Color.ColorSystem.primaryText)
                    .listRowBackground(Color.ColorSystem.systemGray6)
                    .disabled(viewModel.isLoading)
            } header: {
                Text("Height (in)")
            }
            
            Section {
                TextField("", text: $viewModel.weight, axis: .vertical)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.numberPad)
                    .foregroundStyle(Color.ColorSystem.primaryText)
                    .listRowBackground(Color.ColorSystem.systemGray6)
                    .disabled(viewModel.isLoading)
            } header: {
                Text("Weight (lbs)")
            }
            
            Section {
                Button(action: {
                    keyboardIsFocused = false
                    viewModel.isLoading = true
                    
                    viewModel.createNutritionPlan()
                    
                    dismiss()
                }, label: {
                    if viewModel.isLoading {
                        HStack {
                            Spacer()
                            ProgressView()
                                .foregroundStyle(Color.ColorSystem.primaryText)
                            Spacer()
                        }
                    } else {
                        HStack {
                            Spacer()
                            
                            Text("Create nutrition plan")
                                .font(Font.FontStyles.headline)
                            
                            Spacer()
                        }
                    }
                })
                .disabled(viewModel.isLoading)
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
        .sheet(isPresented: $presentSexSelector) {
            DropdownView(options: ["Male", "Female"]) { option in
                viewModel.sex = option
            }
        }
        .sheet(isPresented: $presentGoalSelector) {
            DropdownView(options: ["Lose weight", "Maintain weight", "Gain weight"]) { option in
                viewModel.goal = option
            }
        }
    }
}

#Preview {
    CreateNutritionPlanView(viewModel: CreateNutritionPlanViewModel())
}
