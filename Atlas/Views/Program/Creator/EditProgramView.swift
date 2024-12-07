//
//  EditProgramView.swift
//  Atlas
//
//  Created by Michael Bautista on 12/6/24.
//

import SwiftUI
import PhotosUI

struct EditProgramView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel: EditProgramViewModel
    
    var body: some View {
        NavigationStack {
            List {
                // MARK: Image
                Section {
                    PhotosPicker(selection: $viewModel.imageSelection, matching: .images) {
                        if viewModel.programImage != nil {
                            if let imageData = viewModel.programImage!.pngData() {
                                VStack {
                                    Image(uiImage: UIImage(data: imageData) ?? UIImage())
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 120, height: 120)
                                        .background(Color.ColorSystem.systemGray6)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                                .frame(maxWidth: .infinity)
                            }
                        } else {
                            VStack {
                                VStack {
                                    Image(systemName: "camera.fill")
                                        .foregroundStyle(Color.ColorSystem.systemGray)
                                }
                                .frame(width: 120, height: 120)
                                .background(Color.ColorSystem.systemGray6)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .listRowBackground(Color.ColorSystem.systemBackground)
                    .buttonStyle(.plain)
                }
                
                // MARK: Title
                Section {
                    TextField("", text: $viewModel.title, axis: .vertical)
                        .textInputAutocapitalization(.sentences)
                        .foregroundStyle(Color.ColorSystem.primaryText)
                        .listRowBackground(Color.ColorSystem.systemGray6)
                        .disabled(viewModel.isLoading)
                } header: {
                    Text("Title")
                }
                
                // MARK: Weeks
                Section {
                    TextField("", text: $viewModel.weeks, axis: .vertical)
                        .keyboardType(.numberPad)
                        .foregroundStyle(Color.ColorSystem.primaryText)
                        .listRowBackground(Color.ColorSystem.systemGray6)
                        .disabled(viewModel.isLoading)
                } header: {
                    Text("Weeks")
                }
                
                // MARK: Description
                Section {
                    TextEditor(text: $viewModel.description)
                        .frame(height: 120)
                        .listRowBackground(Color.ColorSystem.systemGray6)
                        .listRowInsets(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
                } header: {
                    Text("Description")
                }
                
                // MARK: Private
                Section {
                    Toggle(isOn: $viewModel.isPrivate) {
                        Text("Private")
                    }
                    .listRowBackground(Color.ColorSystem.systemGray6)
                    .tint(Color.ColorSystem.systemBlue)
                }
                
                // MARK: Free
                Section {
                    Toggle(isOn: $viewModel.free) {
                        Text("Free")
                    }
                    .listRowBackground(Color.ColorSystem.systemGray6)
                    .tint(Color.ColorSystem.systemBlue)
                    
                    SecureField(text: $viewModel.price, prompt: Text("")) {
                        Text("Price")
                    }
                    .textInputAutocapitalization(.never)
                    .keyboardType(.numberPad)
                    .foregroundStyle(Color.ColorSystem.primaryText)
                    .listRowBackground(Color.ColorSystem.systemGray6)
                    .disabled(viewModel.isLoading || viewModel.free)
                } header: {
                    Text("Pricing")
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .scrollDismissesKeyboard(.interactively)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Edit Program")
            .background(Color.ColorSystem.systemBackground)
            .interactiveDismissDisabled(viewModel.isLoading)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .foregroundStyle(Color.ColorSystem.primaryText)
                    }
                    .disabled(viewModel.isLoading)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task {
                            await viewModel.saveProgram()
                            
                            dismiss()
                        }
                    } label: {
                        if !viewModel.isLoading {
                            Text("Save")
                                .foregroundStyle(Color.ColorSystem.systemBlue)
                        } else {
                            ProgressView()
                                .foregroundStyle(Color.ColorSystem.primaryText)
                        }
                    }
                    .disabled(viewModel.isLoading)
                }
            }
            .alert(isPresented: $viewModel.didReturnError, content: {
                Alert(title: Text(viewModel.returnedErrorMessage))
            })
        }
    }
}

#Preview {
    EditProgramView(viewModel: EditProgramViewModel(program: Program(id: "", createdAt: "", createdBy: "", title: "", free: true, price: 0, currency: "", weeks: 8, isPrivate: false), programImage: UIImage()))
}
