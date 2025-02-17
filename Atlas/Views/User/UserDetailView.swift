//
//  UserDetailView.swift
//  Atlas
//
//  Created by Michael Bautista on 9/9/24.
//

import SwiftUI

struct UserDetailView: View {
    @EnvironmentObject var navigationController: NavigationController
    @StateObject var viewModel: UserDetailViewModel
    
    var body: some View {
        if viewModel.isLoading {
            LoadingView()
                .task {
                    await viewModel.getUser(userId: viewModel.userId)
                }
        } else if viewModel.didReturnError {
            ErrorView(errorMessage: viewModel.errorMessage!)
        } else {
            List {
                VStack(alignment: .center) {
                    // MARK: Profile picture
                    if viewModel.userProfilePictureIsLoading {
                        HStack {
                            ProgressView()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        }
                        .frame(maxWidth: .infinity)
                        .listRowBackground(Color.ColorSystem.systemBackground)
                    } else {
                        if viewModel.user?.profilePictureUrl != nil {
                            Image(uiImage: viewModel.userImage!)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        } else {
                            VStack {
                                Image(systemName: "person.circle.fill")
                                    .foregroundStyle(Color.ColorSystem.systemGray)
                            }
                            .frame(width: 100, height: 100)
                            .background(Color.ColorSystem.systemGray6)
                            .clipShape(Circle())
                        }
                    }
                    
                    VStack {
                        // MARK: Full name
                        Text(viewModel.user!.fullName)
                            .font(Font.FontStyles.title1)
                            .foregroundStyle(Color.ColorSystem.primaryText)
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                        
                        // MARK: Username
                        Text("@\(viewModel.user!.username)")
                            .font(Font.FontStyles.body)
                            .foregroundStyle(Color.ColorSystem.systemGray)
                        
                        // MARK: Bio
                        if viewModel.user?.bio != nil {
                            Text(viewModel.user!.bio ?? "")
                                .font(Font.FontStyles.body)
                                .foregroundStyle(Color.ColorSystem.systemGray)
                                .frame(maxWidth: .infinity)
                                .multilineTextAlignment(.center)
                                .listRowSeparator(.hidden)
                                .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
                        }
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                
                // MARK: Subscribe button
                if !viewModel.isCreator {
                    SubscribeButton(
                        viewModel: viewModel,
                        isSubscribed: $viewModel.isSubscribed,
                        isSubscribing: $viewModel.isSubscribing
                    )
                }
                
                // MARK: Content
                if viewModel.user?.stripePriceId != nil {
                    Section {
                        CoordinatorLink {
                            Text("Programs")
                        } action: {
                            navigationController.push(.UserProgramsView(userId: viewModel.user!.id))
                        }
                        
                        if let collections = viewModel.user?.collections {
                            ForEach(collections) { collection in
                                CoordinatorLink {
                                    Text(collection.title)
                                } action: {
                                    navigationController.push(.CollectionDetailView(collectionId: collection.id))
                                }
                            }
                        }
                    }
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.ColorSystem.systemBackground)
            .alert(isPresented: $viewModel.didReturnError, content: {
                Alert(title: Text(viewModel.errorMessage ?? ""))
            })
        }
    }
}

#Preview {
    UserDetailView(viewModel: UserDetailViewModel(userId: "e4d6f88c-d8c3-4a01-98d6-b5d56a366491"))
}
