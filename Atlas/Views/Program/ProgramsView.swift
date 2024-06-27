//
//  ProgramsView.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI

struct ProgramsView: View {
    // MARK: UI State
    @State var presentNewProgram = false
    
    // MARK: Data
    @EnvironmentObject var userViewModel: UserViewModel
    @StateObject private var viewModel = WorkoutViewModel()
    
    @State var path: [SavedProgram] = [SavedProgram]()
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                Section {
                    ForEach(viewModel.programs) { savedProgram in
                        ZStack {
                            ProgramCell(programId: savedProgram.programId)
                            
                            NavigationLink(value: savedProgram) {
                                
                            }
                            .opacity(0)
                        }
                        .listRowInsets(EdgeInsets(top: 16, leading: 20, bottom: 0, trailing: 20))
                        .listRowBackground(Color.ColorSystem.systemGray5)
                        .listRowSeparator(.hidden)
                    }
                    
                    Color.ColorSystem.systemGray5
                        .frame(maxWidth: .infinity)
                        .frame(height: 16)
                        .padding(0)
                        .listRowBackground(Color.ColorSystem.systemGray5)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .listRowSeparator(.hidden)
                    
//                    if !viewModel.isLoading && !viewModel.endReached && viewModel.returnedErrorMessage == nil {
//                        ProgressView()
//                            .frame(maxWidth: .infinity)
//                            .frame(height: 48)
//                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0))
//                            .foregroundStyle(Color.ColorSystem.primaryText)
//                            .onAppear(perform: {
//                                // Get more programs
//                                Task {
//                                    await viewModel.getSavedPrograms()
//                                }
//                            })
//                    }
                }
            }
            .listStyle(.plain)
            .listRowSeparator(.hidden)
            .scrollContentBackground(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(userViewModel.isCreatorView ? "My Programs" : "Saved Programs")
            .background(Color.ColorSystem.systemGray5)
            .onAppear(perform: {
                Task {
                    await viewModel.getSavedPrograms()
                }
            })
            .refreshable(action: {
                await viewModel.pulledRefresh()
            })
            .navigationDestination(for: SavedProgram.self, destination: { program in
                let vm = ProgramDetailViewModel(
                    programId: program.programId
                )
                
                ProgramDetailView(viewModel: vm, onProgramSaved: { savedProgram in
                    #warning("Need to add saved program")
                }, onProgramDelete: {
                    #warning("Need to remove deleted program")
                })
                .toolbarRole(.editor)
            })
            .sheet(isPresented: $presentNewProgram, content: {
                let vm = NewProgramViewModel()
                NewProgramView(viewModel: vm, onProgramCreated: { savedProgram in
                    viewModel.insertProgramToBeginning(newProgram: savedProgram)
                    path.append(savedProgram)
                })
            })
            .alert(isPresented: $viewModel.didReturnError, content: {
                Alert(title: Text(viewModel.returnedErrorMessage ?? "Couldn't get workouts."))
            })
            .toolbar {
                if userViewModel.isCreatorView {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("", systemImage: "plus") {
                            presentNewProgram.toggle()
                        }
                        .tint(Color.ColorSystem.primaryText)
                    }
                }
            }
        }
    }
}

#Preview {
    ProgramsView()
        .environmentObject(UserViewModel())
}
