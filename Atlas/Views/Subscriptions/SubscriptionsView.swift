//
//  SubscriptionsView.swift
//  Atlas
//
//  Created by Michael Bautista on 1/13/25.
//

import SwiftUI

struct SubscriptionsView: View {
    @EnvironmentObject var navigationController: NavigationController
    @StateObject private var viewModel = SubscriptionsViewModel()
    
    var body: some View {
        List {
            Section {
                ForEach(viewModel.subscriptions) { subscription in
                    if let subscribedTo = subscription.subscribedTo
                    {
                        CoordinatorLink {
                            UserCell(
                                profilePictureUrl: subscribedTo.profilePictureUrl,
                                fullName: subscribedTo.fullName,
                                username: subscribedTo.username,
                                bio: subscribedTo.bio
                            )
                        } action: {
                            navigationController.push(.UserDetailView(userId: subscribedTo.id))
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
                            // Get more subscriptions
                            Task {
                                await viewModel.getSubscriptions()
                            }
                        })
                }
            }
        }
        .listStyle(.plain)
        .listRowSeparator(.hidden)
        .scrollContentBackground(.hidden)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Subscriptions")
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
    SubscriptionsView()
}
