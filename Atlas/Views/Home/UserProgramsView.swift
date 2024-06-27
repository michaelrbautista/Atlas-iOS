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
    
    var body: some View {
        List {
            Section {
                ForEach(viewModel.programs) { savedProgram in
                    ZStack {
                        ProgramCell(
                            programId: savedProgram.programId
                        )
                        
                        NavigationLink {
                            ProgramDetailView(viewModel: ProgramDetailViewModel(savedProgram: savedProgram))
                        } label: {
                            
                        }
                        .opacity(0)
                    }
                    .listRowInsets(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
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
                
//                if !viewModel.isLoading && !viewModel.endReached && viewModel.returnedErrorMessage == nil {
//                    ProgressView()
//                        .frame(maxWidth: .infinity)
//                        .frame(height: 48)
//                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0))
//                        .foregroundStyle(Color.ColorSystem.primaryText)
//                        .onAppear(perform: {
//                            // Get more programs
//                            Task {
//                                await viewModel.getCreatorPrograms()
//                            }
//                        })
//                }
            }
        }
        .listStyle(.plain)
        .listRowSeparator(.hidden)
        .scrollContentBackground(.hidden)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Programs")
        .background(Color.ColorSystem.systemGray5)
        .onAppear(perform: {
            Task {
                await viewModel.getCreatorPrograms()
            }
        })
        .refreshable(action: {
                await viewModel.pulledRefresh()
        })
        .alert(isPresented: $viewModel.didReturnError, content: {
            Alert(title: Text(viewModel.returnedErrorMessage ?? "Couldn't get workouts."))
        })
    }
}

#Preview {
    UserProgramsView(viewModel: UserProgramsViewModel(userId: "Test"))
}
