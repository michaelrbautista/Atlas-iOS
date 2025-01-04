//
//  ProgramsView.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI

struct ProgramsView: View {
    // MARK: Data
    @EnvironmentObject var navigationController: NavigationController
    @StateObject private var viewModel = ProgramsViewModel()
    
    var body: some View {
        List {
            Section {
                ForEach(viewModel.programs) { program in
                    if let createdBy = program.createdBy, let checkProgram = program.programs {
                        CoordinatorLink {
                            ProgramCell(
                                title: checkProgram.title,
                                imageUrl: checkProgram.imageUrl,
                                userFullName: createdBy.fullName
                            )
                        } action: {
                            navigationController.push(.ProgramDetailView(programId: checkProgram.id, deleteProgram: {
                                viewModel.programs.remove(program)
                            }))
                        }
                    }
                }
                
                Color.ColorSystem.systemBackground
                    .frame(maxWidth: .infinity)
                    .frame(height: 16)
                    .padding(0)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .listRowSeparator(.hidden)
                
                if !viewModel.isLoading && !viewModel.endReached && viewModel.returnedErrorMessage == "" {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0))
                        .foregroundStyle(Color.ColorSystem.primaryText)
                        .onAppear(perform: {
                            // Get more programs
                            Task {
                                await viewModel.getPurchasedPrograms()
                            }
                        })
                }
            }
        }
        .listStyle(.plain)
        .listRowSeparator(.hidden)
        .scrollContentBackground(.hidden)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Programs")
        .background(Color.ColorSystem.systemBackground)
        .refreshable(action: {
            await viewModel.pulledRefresh()
        })
        .alert(isPresented: $viewModel.didReturnError, content: {
            Alert(title: Text(viewModel.returnedErrorMessage))
        })
    }
}

#Preview {
    ProgramsView()
}
