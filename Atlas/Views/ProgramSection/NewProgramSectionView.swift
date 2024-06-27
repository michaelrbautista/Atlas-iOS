//
//  NewProgramSectionView.swift
//  Atlas
//
//  Created by Michael Bautista on 6/13/24.
//

import SwiftUI

struct NewProgramSectionView: View {
    // MARK: UI state
    @StateObject var viewModel: NewProgramSectionViewModel
    @Environment(\.dismiss) private var dismiss
    @FocusState var keyboardIsFocused: Bool
    
    public var onSectionCreated: ((ProgramSection) -> Void)
    
    var body: some View {
        NavigationStack {
            List {
                // MARK: Text Field
                Section {
                    TextField("Title", text: $viewModel.title, axis: .vertical)
                        .foregroundStyle(Color.ColorSystem.primaryText)
                        .listRowBackground(Color.ColorSystem.systemGray4)
                        .disabled(viewModel.isSaving)
                } header: {
                    Text("Title")
                }
                
                // MARK: Text Field
                Section {
                    TextField("", text: $viewModel.description, prompt: viewModel.description == "" ? Text("Add description...") : Text(""), axis: .vertical)
                        .lineLimit(12...)
                        .listRowBackground(Color.ColorSystem.systemGray4)
                        .disabled(viewModel.isSaving)
                } header: {
                    Text("Description")
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("New Section")
            .background(Color.ColorSystem.systemGray5)
            .alert(isPresented: $viewModel.didReturnError, content: {
                Alert(title: Text(viewModel.returnedErrorMessage ?? "Couldn't save section."))
            })
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .tint(Color.ColorSystem.primaryText)
                    .disabled(viewModel.isSaving)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    if viewModel.isSaving {
                        ProgressView()
                            .foregroundStyle(Color.ColorSystem.primaryText)
                    } else {
                        Button("Save") {
                            keyboardIsFocused = false
                            
                            // Save workout
                            Task {
                                let savedProgramSection = await viewModel.createNewProgramSection()
                                
                                if let savedProgramSection = savedProgramSection {
                                    self.onSectionCreated(savedProgramSection)
                                    dismiss()
                                }
                            }
                        }
                        .tint(Color.ColorSystem.systemBlue)
                        .disabled(viewModel.title == "")
                    }
                }
            })
        }
    }
}

#Preview {
    NewProgramSectionView(viewModel: NewProgramSectionViewModel(programId: "", sectionNumber: 1), onSectionCreated: {_ in })
}
