//
//  WorkoutView.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI

struct WorkoutView: View {
    // MARK: UI State
    @State private var createProgramIsPresented = false
    
    // MARK: Data
    @EnvironmentObject var userViewModel: UserViewModel
    @StateObject private var viewModel = WorkoutViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(
                    columns: [
                    GridItem(.flexible(), spacing: 16, alignment: nil),
                    GridItem(.flexible(), spacing: 16, alignment: nil)
                    ],
                    spacing: 16,
                    content: {
                        ForEach(viewModel.programs) { program in
                            NavigationLink(value: program) {
                                CellView(
                                    imageUrl: program.imageUrl,
                                    title: program.title,
                                    creator: program.username
                                )
                            }
                        }
                })
                .navigationDestination(for: SavedProgram.self, destination: { program in
                    let vm = ProgramDetailViewModel(
                        programId: program.programId
                    )
                    
                    ProgramDetailView(viewModel: vm, onProgramSaved: { savedProgram in
                        #warning("Need to remove deleted program")
                    }, onProgramDelete: {
                        #warning("Need to remove deleted program")
                    })
                })
                .padding(16)
                
                if !viewModel.isLoading && !viewModel.endReached && viewModel.returnedErrorMessage != nil {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0))
                        .foregroundStyle(Color.ColorSystem.primaryText)
                        .onAppear(perform: {
                            guard let currentUserUid = UserService.currentUser?.uid else {
                                print("Error getting more workouts.")
                                return
                            }
                            
                            let getMySavedProgramsRequest = GetProgramsRequest(
                                uid: currentUserUid, lastProgramRef: viewModel.lastProgramFetchedRef
                            )
                            
                            Task {
                                await viewModel.getMySavedPrograms(getMySavedProgramsRequest: getMySavedProgramsRequest)
                            }
                        })
                }
            }
            .background(Color.ColorSystem.systemGray5)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Workout")
            .refreshable(action: {
                await viewModel.pulledRefresh()
            })
            .fullScreenCover(isPresented: $createProgramIsPresented, content: {
                let vm = CreateProgramViewModel()
                CreateProgramView(viewModel: vm, onProgramSaved:  { savedProgram in
                    viewModel.insertProgramToBeginning(newProgram: savedProgram)
                })
            })
            .alert(isPresented: $viewModel.didReturnError, content: {
                Alert(title: Text(viewModel.returnedErrorMessage ?? "Couldn't get workouts."))
            })
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("", systemImage: "plus") {
                        createProgramIsPresented.toggle()
                    }
                    .tint(Color.ColorSystem.primaryText)
                }
            }
        }
    }
}

#Preview {
    WorkoutView()
}
