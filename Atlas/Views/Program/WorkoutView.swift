//
//  WorkoutView.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI

struct WorkoutView: View {
    // MARK: UI State
    @State private var presentNewProgram = false
    
    // MARK: Data
    @EnvironmentObject var userViewModel: UserViewModel
    @StateObject private var viewModel = WorkoutViewModel()
    
    @State var path: [SavedProgram] = [SavedProgram]()
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                Section {
                    ForEach(viewModel.programs) { savedProgram in
                        ProgramCell(programId: savedProgram.programId)
                            .listRowInsets(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
                            .listRowBackground(Color.ColorSystem.systemGray5)
                            .listRowSeparator(.hidden)
                    }
                    
                    if !viewModel.isLoading && !viewModel.endReached && viewModel.returnedErrorMessage != nil {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0))
                            .foregroundStyle(Color.ColorSystem.primaryText)
                            .onAppear(perform: {
                                // Get more programs
                                Task {
                                    await viewModel.getSavedPrograms()
                                }
                            })
                    }
                }
            }
            .listStyle(.plain)
            .listRowSeparator(.hidden)
            .scrollContentBackground(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("My Programs")
            .background(Color.ColorSystem.systemGray5)
            .scrollContentBackground(.hidden)
            .refreshable(action: {
//                await viewModel.pulledRefresh()
            })
            .navigationDestination(for: SavedProgram.self, destination: { program in
//                let vm = ProgramDetailViewModel(
//                    savedProgram: program
//                )
                
//                ProgramDetailView(viewModel: vm, onProgramSaved: { savedProgram in
//                    #warning("Need to add saved program")
//                }, onProgramDelete: {
//                    #warning("Need to remove deleted program")
//                })
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
    EmptyView()
//    WorkoutView()
}
