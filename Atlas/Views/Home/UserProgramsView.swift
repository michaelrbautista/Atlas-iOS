//
//  UserProgramsView.swift
//  stayhard
//
//  Created by Michael Bautista on 3/26/24.
//

import SwiftUI

struct UserProgramsView: View {
    // MARK: Data
    @StateObject var viewModel: UserProgramsViewModel
    
    // If user is navigating from home page, don't show plus in navigation bar
    public var isFromHomePage: Bool
    
    @State private var createProgramIsPresented = false
    
    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: [
                GridItem(.flexible(), spacing: 16, alignment: nil),
                GridItem(.flexible(), spacing: 16, alignment: nil)
                ], 
                spacing: 16,
                content: {
                    ForEach(viewModel.programs) { program in
                        NavigationLink {
                            let vm = ProgramDetailViewModel(
                                programId: program.programId
                            )
                            
                            ProgramDetailView(viewModel: vm)
                        } label: {
                            CellView(
                                imageUrl: program.imageUrl,
                                title: program.title,
                                creator: program.username
                            )
                        }
                    }
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
                        
                        let getProgramsRequest = GetProgramsRequest(
                            uid: currentUserUid, lastProgramRef: viewModel.lastProgramFetchedRef
                        )
                        
                        Task {
                            await viewModel.getCreatorPrograms(getProgramsRequest: getProgramsRequest)
                        }
                    })
            }
        }
        .background(Color.ColorSystem.systemGray5)
        .navigationTitle("Programs")
        .refreshable(action: {
            await viewModel.pulledRefresh()
        })
        .toolbar(content: {
            if !isFromHomePage {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("", systemImage: "plus") {
                        createProgramIsPresented.toggle()
                    }
                }
            }
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
    }
}

#Preview {
    UserProgramsView(viewModel: UserProgramsViewModel(creatorUid: "7VNj6cg8u7Ndo8JwG5KevruLpEh1"), isFromHomePage: true)
}
