//
//  ExploreView.swift
//  Atlas
//
//  Created by Michael Bautista on 10/4/24.
//

import SwiftUI

struct ExploreView: View {
    @EnvironmentObject var navigationController: NavigationController
    @EnvironmentObject var userViewModel: UserViewModel
    @StateObject private var viewModel = ExploreViewModel()
    
    var body: some View {
        List {
            if viewModel.isLoading {
                VStack(alignment: .center) {
                    Spacer()
                    ProgressView()
                        .frame(maxWidth: UIScreen.main.bounds.size.width)
                        .tint(Color.ColorSystem.primaryText)
                    Spacer()
                }
                .background(Color.ColorSystem.systemBackground)
                .navigationBarTitleDisplayMode(.inline)
                .alert(isPresented: $viewModel.didReturnError, content: {
                    Alert(title: Text(viewModel.returnedErrorMessage))
                })
            } else {
                if viewModel.searchText != "" {
                    if viewModel.filter == "Programs" {
                        ForEach(viewModel.programs) { program in
                            CoordinatorLink {
                                SearchProgramCell(program: program)
                            } action: {
                                navigationController.push(.ProgramDetailView(programId: program.id, deleteProgram: {}))
                            }
                        }
                    } else {
                        ForEach(viewModel.users) { user in
                            CoordinatorLink {
                                SearchUserCell(user: user)
                            } action: {
                                navigationController.push(.UserDetailView(userId: user.id))
                            }
                        }
                    }
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Explore")
        .background(Color.ColorSystem.systemBackground)
        .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always))
        .onSubmit(of: .search, {
            Task {
                await viewModel.search()
            }
        })
        .alert(isPresented: $viewModel.didReturnError, content: {
            Alert(title: Text(viewModel.returnedErrorMessage))
        })
    }
}

#Preview {
    ExploreView()
}
