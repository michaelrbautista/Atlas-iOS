//
//  NewProgramView.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI
import PhotosUI

struct NewProgramView: View {
    // MARK: UI State
    @StateObject var viewModel: NewProgramViewModel
    @Environment(\.dismiss) private var dismiss
    @FocusState var keyboardIsFocused: Bool
    
    public var onProgramCreated: ((SavedProgram) -> Void)?
    
    var body: some View {
        NavigationStack {
            List {
                // MARK: Image
                Section {
                    VStack {
                        // Add photo
                        if let image = viewModel.programImage {
                            PhotosPicker(selection: $viewModel.imageSelection, matching: .images) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: UIScreen.main.bounds.size.width / 2, alignment: .center)
                                    .background(Color.ColorSystem.systemGray4)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                    .foregroundStyle(Color.ColorSystem.secondaryText)
                            }
                            .buttonStyle(.plain)
                            .disabled(viewModel.isSaving)
                        } else {
                            PhotosPicker(selection: $viewModel.imageSelection, matching: .images) {
                                Image(systemName: "camera.fill")
                                    .frame(maxWidth: .infinity)
                                    .frame(height: UIScreen.main.bounds.size.width / 2, alignment: .center)
                                    .background(Color.ColorSystem.systemGray4)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                    .foregroundStyle(Color.ColorSystem.secondaryText)
                            }
                            .buttonStyle(.plain)
                            .disabled(viewModel.isSaving)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .listRowSeparator(.hidden)
                }
                .background(Color.ColorSystem.systemGray5)
                
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
                } header: {
                    Text("Description")
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("New Program")
            .background(Color.ColorSystem.systemGray5)
            .alert(isPresented: $viewModel.didReturnError, content: {
                Alert(title: Text(viewModel.returnedErrorMessage ?? "Couldn't save program."))
            })
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .tint(Color.ColorSystem.primaryText)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    if viewModel.isSaving {
                        ProgressView()
                            .foregroundStyle(Color.ColorSystem.primaryText)
                    } else {
                        Button("Save") {
                            keyboardIsFocused = false
                            
                            // Save program
                            Task {
                                let savedProgram = await viewModel.createNewProgram()
                                
                                if let savedProgram = savedProgram {
                                    self.onProgramCreated?(savedProgram)
                                }
                                
                                dismiss()
                            }
                        }
                        .tint(Color.ColorSystem.systemBlue)
                    }
                }
            })
        }
    }
}

#Preview {
    NewProgramView(viewModel: NewProgramViewModel(), onProgramCreated: {_ in })
}
