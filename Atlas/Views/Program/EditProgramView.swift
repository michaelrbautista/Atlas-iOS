//
//  EditProgramView.swift
//  Atlas
//
//  Created by Michael Bautista on 4/16/24.
//

import SwiftUI
import PhotosUI

struct EditProgramView: View {
    // MARK: UI State
    @StateObject var viewModel: EditProgramViewModel
    @Environment(\.dismiss) private var dismiss
    @Binding var presentEditProgram: Bool
    
    public var onProgramSaved: ((Program, UIImage) -> Void)?
    
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
                                    .frame(width: UIScreen.main.bounds.size.width / 2, height: UIScreen.main.bounds.size.width / 2, alignment: .center)
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
                                    .frame(width: UIScreen.main.bounds.size.width / 2, height: UIScreen.main.bounds.size.width / 2, alignment: .center)
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
                
                // MARK: Title
                Section {
                    TextField("Title", text: $viewModel.program.title, axis: .vertical)
                        .foregroundStyle(Color.ColorSystem.primaryText)
                        .listRowBackground(Color.ColorSystem.systemGray4)
                        .disabled(viewModel.isSaving)
                } header: {
                    Text("Title")
                }
                
                // MARK: Description
                Section {
                    TextField("", text: $viewModel.program.description, prompt: viewModel.program.description == "" ? Text("Add description...") : Text(""), axis: .vertical)
                        .lineLimit(12...)
                        .listRowBackground(Color.ColorSystem.systemGray4)
                } header: {
                    Text("Description")
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Edit Program")
            .background(Color.ColorSystem.systemGray5)
            .alert(isPresented: $viewModel.didReturnError, content: {
                Alert(title: Text(viewModel.returnedErrorMessage ?? "Couldn't save program."))
            })
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        EditProgramWorkoutsView(presentEditProgram: $presentEditProgram, onProgramSaved: onProgramSaved)
                            .environmentObject(viewModel)
                            .toolbarRole(.editor)
                    } label: {
                        Text("Next")
                            .foregroundStyle(viewModel.program.title == "" ? Color.ColorSystem.secondaryText : Color.ColorSystem.systemBlue)
                    }
                    .disabled(viewModel.program.title == "")
                }
            })
        }
    }
}

#Preview {
    EmptyView()
//    EditProgramView(viewModel: EditProgramViewModel(programImage: UIImage(), program: Program(title: "", description: "", created_by: "")), presentEditProgram: .constant(true), onProgramSaved: {_, _  in })
}
