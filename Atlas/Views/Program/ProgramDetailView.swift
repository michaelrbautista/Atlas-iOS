//
//  ProgramDetailView.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI
import PhotosUI

struct ProgramDetailView: View {
    // MARK: UI state
    @Environment(\.dismiss) private var dismiss
    @FocusState var keyboardIsFocused: Bool
    
    @State private var presentProgramInfo = false
    @State private var presentEditProgram = false
    @State private var presentConfirmUnsave = false
    @State private var presentConfirmDelete = false
    
    // MARK: Data
    @StateObject var viewModel: ProgramDetailViewModel
    
    public var onProgramSaved: ((SavedProgram) -> Void)?
    public var onProgramDelete: (() -> Void)?
    
    var body: some View {
        if viewModel.programIsLoading == true || viewModel.program == nil {
            VStack(alignment: .center) {
                Spacer()
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .tint(Color.ColorSystem.primaryText)
                Spacer()
            }
            .background(Color.ColorSystem.systemGray5)
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $viewModel.didReturnError, content: {
                Alert(title: Text(viewModel.returnedErrorMessage))
            })
        } else {
            List {
                Section {
//                    VStack(spacing: 16) {
//                        // MARK: Image
//                        HStack {
//                            Spacer()
//                            if viewModel.program?.image_url != nil {
//                                if viewModel.programImage != nil {
//                                    Image(uiImage: viewModel.programImage!)
//                                        .resizable()
//                                        .scaledToFill()
//                                        .frame(width: UIScreen.main.bounds.size.width / 2, height: UIScreen.main.bounds.size.width / 2, alignment: .center)
//                                        .clipShape(RoundedRectangle(cornerRadius: 10))
//                                        .background(Color.ColorSystem.systemGray3)
//                                        .foregroundStyle(Color.ColorSystem.secondaryText)
//                                } else {
//                                    ProgressView()
//                                        .frame(width: UIScreen.main.bounds.size.width / 2, height: UIScreen.main.bounds.size.width / 2, alignment: .center)
//                                        .frame(maxWidth: .infinity, alignment: .center)
//                                        .tint(Color.ColorSystem.primaryText)
//                                        .clipShape(RoundedRectangle(cornerRadius: 10))
//                                }
//                            } else {
//                                VStack {
//                                    Spacer()
//                                    Image(systemName: "figure.run")
//                                        .resizable()
//                                        .scaledToFit()
//                                        .frame(height: 48)
//                                        .foregroundStyle(Color.ColorSystem.secondaryText)
//                                    Spacer()
//                                }
//                                .frame(width: UIScreen.main.bounds.size.width / 2, height: UIScreen.main.bounds.size.width / 2, alignment: .center)
//                                .background(Color.ColorSystem.systemGray4)
//                                .clipShape(RoundedRectangle(cornerRadius: 8))
//                            }
//                            
//                            Spacer()
//                        }
//                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
//                        .listRowSeparator(.hidden)
//                        .listRowBackground(Color.ColorSystem.systemGray5)
//                        
//                        // MARK: Title
//                        VStack(spacing: 4) {
//                            Text(viewModel.program?.title ?? "")
//                                .font(Font.FontStyles.title1)
//                                .foregroundStyle(Color.ColorSystem.primaryText)
//                                .multilineTextAlignment(.center)
//                            
//                            Text("@")
//                                .font(Font.FontStyles.headline)
//                                .foregroundStyle(Color.ColorSystem.secondaryText)
//                        }
//                        
//                        // MARK: Save button
//                        VStack {
//                            Button(action: {
//                                if viewModel.programIsSaved {
//                                    presentConfirmUnsave.toggle()
//                                } else {
//                                    viewModel.saveProgram(program: viewModel.program!)
//                                }
//                            }, label: {
//                                if viewModel.checkingIfUserSavedProgram || viewModel.programIsSaving {
//                                    ProgressView()
//                                        .foregroundStyle(Color.ColorSystem.primaryText)
//                                        .frame(maxWidth: .infinity)
//                                        .frame(height: 40)
//                                        .background(Color.ColorSystem.systemGray4)
//                                        .clipShape(RoundedRectangle(cornerRadius: 10))
//                                } else {
//                                    if viewModel.programIsSaved {
//                                        Text("Saved")
//                                            .font(Font.FontStyles.headline)
//                                            .foregroundStyle(Color.ColorSystem.secondaryText)
//                                            .frame(maxWidth: .infinity)
//                                            .frame(height: 40)
//                                            .background(Color.ColorSystem.systemGray4)
//                                            .clipShape(RoundedRectangle(cornerRadius: 10))
//                                    } else {
//                                        Text("Save")
//                                            .font(Font.FontStyles.headline)
//                                            .foregroundStyle(Color.ColorSystem.primaryText)
//                                            .frame(maxWidth: .infinity)
//                                            .frame(height: 40)
//                                            .background(viewModel.checkingIfUserSavedProgram ? Color.ColorSystem.systemGray4 : Color.ColorSystem.systemBlue)
//                                            .clipShape(RoundedRectangle(cornerRadius: 10))
//                                    }
//                                }
//                            })
//                            .buttonStyle(.plain)
//                            .disabled(viewModel.checkingIfUserSavedProgram || viewModel.programIsSaving)
//                        }
//                        .padding(EdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 0))
//                        .buttonStyle(.plain)
//                    }
                }
                
                // MARK: Description
                if viewModel.program?.description != "" {
                    Section {
                        Text(viewModel.program!.description)
                            .listRowBackground(Color.ColorSystem.systemGray4)
                    }
                }
                
                // MARK: Workouts
                Section {
//                    ForEach(viewModel.program!.workouts) { workout in
//                        NavigationLink {
//                            WorkoutDetailView(workout: workout)
//                                .environmentObject(viewModel)
//                        } label: {
//                            HStack {
//                                Text(workout.title)
//                                    .font(Font.FontStyles.body)
//                                    .foregroundStyle(Color.ColorSystem.primaryText)
//                                Spacer()
//                            }
//                        }
//                        .listRowBackground(Color.ColorSystem.systemGray4)
//                    }
                } header: {
                    Text("Workouts")
                        .foregroundStyle(Color.ColorSystem.primaryText)
                }
                .headerProminence(.increased)
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.ColorSystem.systemGray5)
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
//                    if UserService.currentUser?.id == viewModel.program?.uid {
//                        Menu("", systemImage: "ellipsis") {
//                            Button("Edit", role: .none) {
//                                presentEditProgram.toggle()
//                            }
//                            
//                            Button("Delete", role: .destructive) {
//                                presentConfirmDelete.toggle()
//                            }
//                        }
//                    }
                }
            })
            .fullScreenCover(isPresented: $presentEditProgram, content: {
                EditProgramView(viewModel: EditProgramViewModel(
                    programImage: viewModel.programImage,
                    program: viewModel.program!), presentEditProgram: $presentEditProgram) { editedProgram, programImage in
                        viewModel.program = editedProgram
                        viewModel.programImage = programImage
                    }
            })
            .alert(Text("Delete program?"), isPresented: $presentConfirmDelete) {
                Button(role: .destructive) {
                    viewModel.deleteProgram()
                    dismiss()
                } label: {
                    Text("Delete")
                }
            }
            .alert(Text("Unsave program?"), isPresented: $presentConfirmUnsave) {
                Button(role: .destructive) {
//                    viewModel.unsaveProgram(programId: viewModel.program!.id)
                } label: {
                    Text("Unsave")
                }
            }
        }
    }
}

#Preview {
    EmptyView()
//    ProgramDetailView(viewModel: ProgramDetailViewModel(savedProgram: SavedProgram(program_id: "", saved_by: "", created_by: "")))
}
