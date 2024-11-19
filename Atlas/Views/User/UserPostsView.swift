//
//  UserPostsView.swift
//  Atlas
//
//  Created by Michael Bautista on 11/7/24.
//

import SwiftUI

struct UserPostsView: View {
    // MARK: UI state
    @Environment(\.dismiss) private var dismiss
    @FocusState var keyboardIsFocused: Bool
    
    // MARK: Data
    @StateObject var viewModel: UserPostsViewModel
    
    var body: some View {
        List {
            Section {
                ForEach(viewModel.posts) { post in
                    ZStack {
                        PostCell(post: post)
                        
                        NavigationLink(value: NavigationDestinationTypes.PostDetail(post: post)) {
                            
                        }
                        .opacity(0)
                    }
                    .listRowInsets(EdgeInsets(top: 16, leading: 20, bottom: 0, trailing: 20))
                    .listRowSeparator(.hidden)
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
                                await viewModel.getCreatorsPosts()
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
    UserPostsView(viewModel: UserPostsViewModel(userId: ""))
}
