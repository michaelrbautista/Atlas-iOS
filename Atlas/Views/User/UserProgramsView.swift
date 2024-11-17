//
//  TeamProgramsView.swift
//  Atlas
//
//  Created by Michael Bautista on 9/9/24.
//

import SwiftUI

struct TeamProgramsView: View {
    // MARK: UI state
    @Environment(\.dismiss) private var dismiss
    @FocusState var keyboardIsFocused: Bool
    
    // MARK: Data
    @StateObject var viewModel: TeamProgramsViewModel
    
    var body: some View {
        List {
            Section {
                ForEach(viewModel.programs) { program in
                    ZStack {
//                        ProgramCell(programId: program.id)
//                        
//                        NavigationLink(value: NavigationDestinationTypes.ProgramDetail(programId: program.id)) {
//                            
//                        }
//                        .opacity(0)
                    }
                    .listRowInsets(EdgeInsets(top: 16, leading: 20, bottom: 0, trailing: 20))
                    .listRowSeparator(.hidden)
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
        .navigationTitle("Programs")
        .background(Color.ColorSystem.systemBackground)
        .refreshable(action: {
            await viewModel.pulledRefresh()
        })
        .alert(isPresented: $viewModel.didReturnError, content: {
            Alert(title: Text(viewModel.returnedErrorMessage ?? "Couldn't get programs."))
        })
    }
}

#Preview {
    TeamProgramsView(viewModel: TeamProgramsViewModel(teamId: ""))
}
