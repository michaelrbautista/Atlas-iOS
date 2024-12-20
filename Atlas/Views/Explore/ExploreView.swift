//
//  ExploreView.swift
//  Atlas
//
//  Created by Michael Bautista on 10/4/24.
//

import SwiftUI

struct ExploreView: View {
    
    // MARK: Data
    @EnvironmentObject var userViewModel: UserViewModel
    @StateObject private var viewModel = ExploreViewModel()
    
    @State var path = [RootNavigationTypes]()
    
    var body: some View {
        NavigationStack(path: $path) {
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
                                NavigationLink(value: RootNavigationTypes.ProgramDetailView(programId: program.id)) {
                                    SearchProgramCell(program: program)
                                }
                            }
                        } else {
                            ForEach(viewModel.users) { user in
                                NavigationLink(value: RootNavigationTypes.UserDetailView(userId: user.id)) {
                                    SearchUserCell(user: user)
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
            .rootNavigationDestination(path: $path)
        }
    }
}

#Preview {
    ExploreView()
}
