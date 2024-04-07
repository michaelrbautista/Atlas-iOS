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
    
    @State private var confirmUnsave = false
    @State private var presentProgramInfo = false
    @State private var editProgram = false
    @State private var confirmDelete = false
    
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
                    VStack(spacing: 16) {
                        // MARK: Image
                        HStack {
                            Spacer()
                            
                            if viewModel.programImage != nil {
                                Image(uiImage: viewModel.programImage!)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: UIScreen.main.bounds.size.width / 2, height: UIScreen.main.bounds.size.width / 2, alignment: .center)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            } else {
                                ProgressView()
                                    .frame(width: UIScreen.main.bounds.size.width / 2, height: UIScreen.main.bounds.size.width / 2, alignment: .center)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .tint(Color.ColorSystem.primaryText)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            
                            Spacer()
                        }
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.ColorSystem.systemGray5)
                        
                        // MARK: Title
                        VStack(spacing: 4) {
                            Text(viewModel.program?.title ?? "")
                                .font(Font.FontStyles.title1)
                                .foregroundStyle(Color.ColorSystem.primaryText)
                                .multilineTextAlignment(.center)
                            
                            Text("@\(viewModel.user?.username ?? "")")
                                .font(Font.FontStyles.headline)
                                .foregroundStyle(Color.ColorSystem.secondaryText)
                        }
                        
                        // MARK: Save button
                        VStack {
                            Button(action: {
                                if viewModel.programIsSaved {
                                    confirmUnsave.toggle()
                                } else {
                                    viewModel.saveProgram(program: viewModel.program!)
                                }
                            }, label: {
                                if viewModel.checkingIfUserSavedProgram || viewModel.programIsSaving {
                                    ProgressView()
                                        .foregroundStyle(Color.ColorSystem.primaryText)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 40)
                                        .background(Color.ColorSystem.systemGray4)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                } else {
                                    if viewModel.programIsSaved {
                                        Text("Saved")
                                            .font(Font.FontStyles.headline)
                                            .foregroundStyle(Color.ColorSystem.secondaryText)
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 40)
                                            .background(Color.ColorSystem.systemGray4)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    } else {
                                        Text("Save")
                                            .font(Font.FontStyles.headline)
                                            .foregroundStyle(Color.ColorSystem.primaryText)
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 40)
                                            .background(viewModel.checkingIfUserSavedProgram ? Color.ColorSystem.systemGray4 : Color.ColorSystem.systemBlue)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    }
                                }
                            })
                            .buttonStyle(.plain)
                            .disabled(viewModel.checkingIfUserSavedProgram || viewModel.programIsSaving)
                        }
                        .padding(EdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 0))
                        .buttonStyle(.plain)
                    }
                }
                
                // MARK: Description
                if viewModel.program?.description != "" {
                    Section {
                        Text(viewModel.program!.description ?? "")
                            .listRowBackground(Color.ColorSystem.systemGray4)
                    }
                }
                
                // MARK: Workouts
                Section {
                    ForEach(viewModel.program!.workouts) { workout in
                        NavigationLink {
                            WorkoutDetailView(workoutTitle: workout.title, workoutDescription: workout.description ?? "", exercises: workout.exercises)
                        } label: {
                            HStack {
                                Text(workout.title)
                                    .font(Font.FontStyles.body)
                                    .foregroundStyle(Color.ColorSystem.primaryText)
                                Spacer()
                            }
                        }
                        .listRowBackground(Color.ColorSystem.systemGray4)
                    }
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
                    if viewModel.currentUser?.uid == viewModel.user!.uid {
                        Menu("", systemImage: "ellipsis") {
                            Button("Edit", role: .none) {
                                editProgram.toggle()
                            }
                            
                            Button("Delete", role: .destructive) {
                                confirmDelete.toggle()
                            }
                        }
                    }
                }
            })
            .fullScreenCover(isPresented: $editProgram, content: {
                EditProgramView(viewModel: EditProgramViewModel(
                    programImage: viewModel.programImage ?? UIImage(),
                    program: viewModel.program!,
                    programTitle: viewModel.program!.title,
                    programDescription: viewModel.program!.description ?? "",
                    programWorkouts: viewModel.program!.workouts)) { programImage, program in
                        viewModel.programImage = programImage
                        viewModel.program = program
                    }
            })
            .alert(Text("Delete program?"), isPresented: $confirmDelete) {
                Button(role: .destructive) {
                    viewModel.deleteProgram()
                    dismiss()
                } label: {
                    Text("Delete")
                }
            }
            .alert(Text("Unsave program?"), isPresented: $confirmUnsave) {
                Button(role: .destructive) {
                    viewModel.unsaveProgram(programId: viewModel.program!.id)
                } label: {
                    Text("Unsave")
                }
            }
        }
    }
}

#Preview {
    ProgramDetailView(viewModel: ProgramDetailViewModel(programId: "KCwEEk01tszmHqZauNNj"))
}
