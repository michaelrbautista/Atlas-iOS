//
//  UserProgramsView.swift
//  Atlas
//
//  Created by Michael Bautista on 9/9/24.
//

import SwiftUI

struct UserProgramsView: View {
    // MARK: UI state
    @Environment(\.dismiss) private var dismiss
    @FocusState var keyboardIsFocused: Bool
    
    // MARK: Data
    @StateObject var viewModel: UserProgramsViewModel
    
    var body: some View {
        List {
            Section {
                ForEach(viewModel.programs) { program in
                    if let createdBy = program.createdBy {
                        NavigationLink(value: RootNavigationTypes.ProgramDetailView(programId: program.id)) {
                            ProgramCell(title: program.title, imageUrl: program.imageUrl, userFullName: createdBy.fullName)
                        }
                    }
                }
                
                if !viewModel.isLoading && !viewModel.endReached && viewModel.returnedErrorMessage == "" {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0))
                        .foregroundStyle(Color.ColorSystem.primaryText)
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
    UserProgramsView(viewModel: UserProgramsViewModel(userId: ""))
}
