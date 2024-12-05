//
//  CreatorProgramsView.swift
//  Atlas
//
//  Created by Michael Bautista on 12/5/24.
//

import SwiftUI

struct CreatorProgramsView: View {
    // MARK: Data
    @StateObject private var viewModel = CreatorProgramsViewModel()
    
    @Binding var path: [NavigationDestinationTypes]
    
    var body: some View {
        List {
            Section {
                ForEach(viewModel.programs) { program in
                    ZStack {
                        if let createdBy = program.createdBy {
                            NavigationLink(value: NavigationDestinationTypes.ProgramDetail(programId: program.id)) {
                                ProgramCell(title: program.title, imageUrl: program.imageUrl, userFullName: createdBy.fullName)
                            }
                        }
                    }
                }
                
                Color.ColorSystem.systemBackground
                    .frame(maxWidth: .infinity)
                    .frame(height: 16)
                    .padding(0)
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
        .navigationTitle("My Programs")
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
    CreatorProgramsView(path: .constant([]))
}
