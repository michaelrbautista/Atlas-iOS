//
//  CreatorProgramsView.swift
//  Atlas
//
//  Created by Michael Bautista on 12/5/24.
//

import SwiftUI

struct CreatorProgramsView: View {
    // MARK: Data
    @EnvironmentObject var navigationController: NavigationController
    @StateObject private var viewModel = CreatorProgramsViewModel()
    
    var body: some View {
        List {
            Section {
                ForEach(viewModel.programs) { program in
                    if let createdBy = program.createdBy {
                        CoordinatorLink {
                            ProgramCell(title: program.title, imageUrl: program.imageUrl, userFullName: createdBy.fullName)
                        } action: {
                            navigationController.push(.ProgramDetailView(programId: program.id, deleteProgram: { viewModel.programs.remove(program)
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
                
                if !viewModel.endReached && viewModel.returnedErrorMessage == "" {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0))
                        .listRowSeparator(.hidden)
                        .onAppear(perform: {
                            // Get more programs
                            Task {
                                await viewModel.getCreatorsPrograms()
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
        .background(Color.ColorSystem.systemBackground)
        .refreshable(action: {
            await viewModel.pulledRefresh()
        })
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    navigationController.presentSheet(.NewProgramView(addProgram: { newProgram in
                        viewModel.programs.insert(newProgram, at: 0)
                    }))
                } label: {
                    Image(systemName: "plus")
                }
            }
        })
        .alert(isPresented: $viewModel.didReturnError, content: {
            Alert(title: Text(viewModel.returnedErrorMessage))
        })
    }
}

#Preview {
    CreatorProgramsView()
}
