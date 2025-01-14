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
            .alert(isPresented: $viewModel.didReturnError, content: {
                Alert(title: Text(viewModel.errorMessage ?? "Couldn't get team."))
            })
        } else {
            List {
                VStack(alignment: .center) {
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
                        Text(viewModel.user!.fullName)
                            .font(Font.FontStyles.title3)
                            .foregroundStyle(Color.ColorSystem.primaryText)
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                        
                        Text("@\(viewModel.user!.username)")
                            .font(Font.FontStyles.body)
                            .foregroundStyle(Color.ColorSystem.systemGray)
                        
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
                .listRowSeparator(.hidden)
                
                // MARK: Content
                Section {
                    Button {
                        navigationController.push(.UserProgramsView(userId: viewModel.user!.id))
                    } label: {
                        VStack {
                            HStack(spacing: 16) {
                                Image(systemName: "figure.run")
                                    .frame(width: 20)
                                    .foregroundStyle(Color.ColorSystem.primaryText)
                                
                                Text("Programs")
                                    .font(Font.FontStyles.body)
                                    .foregroundStyle(Color.ColorSystem.primaryText)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 12)
                                    .foregroundStyle(Color.ColorSystem.systemGray2)
                                    .fontWeight(.bold)
                            }
                            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color.ColorSystem.systemGray6)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .buttonStyle(.plain)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
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
