//
//  NewProgramView.swift
//  Atlas
//
//  Created by Michael Bautista on 12/5/24.
//

import SwiftUI
import PhotosUI

struct NewProgramView: View {
    @EnvironmentObject var navigationController: NavigationController
    @StateObject var viewModel = NewProgramViewModel()
    
    // Program: newly created program
    var addProgram: ((Program) -> Void)
    
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
                
                // MARK: Price
                Section {
                    Toggle(isOn: $viewModel.free) {
                        Text("Free")
                    }
                    .listRowBackground(Color.ColorSystem.systemGray6)
                    .tint(Color.ColorSystem.systemBlue)
                    
                    TextField(text: $viewModel.price) {
                        Text("Price")
                    }
                    .textInputAutocapitalization(.never)
                    .keyboardType(.decimalPad)
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
            .navigationTitle("New Program")
            .background(Color.ColorSystem.systemBackground)
            .interactiveDismissDisabled(viewModel.isLoading)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        navigationController.dismissSheet()
                    } label: {
                        Text("Cancel")
                            .foregroundStyle(Color.ColorSystem.primaryText)
                    }
                    .disabled(viewModel.isLoading)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task {
                            let newProgram = await viewModel.saveProgram()
                            
                            if !viewModel.didReturnError && newProgram != nil {
                                addProgram(newProgram!)
                                navigationController.dismissSheet()
                            }
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
    NewProgramView(addProgram: { workout in })
}
