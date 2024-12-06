//
//  UserDetailView.swift
//  Atlas
//
//  Created by Michael Bautista on 9/9/24.
//

import SwiftUI

struct UserDetailView: View {
    // MARK: UI state
    @Environment(\.dismiss) private var dismiss
    @FocusState var keyboardIsFocused: Bool
    
    // MARK: Data
    @StateObject var viewModel: UserDetailViewModel
    
    var body: some View {
        if viewModel.user == nil || viewModel.isLoading {
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
                Alert(title: Text(viewModel.errorMessage ?? "Couldn't get team."))
            })
        } else {
            List {
                // MARK: Image
                Section {
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
                            HStack {
                                Image(uiImage: viewModel.userImage!)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: UIScreen.main.bounds.size.width / 3, height: UIScreen.main.bounds.size.width / 3)
                                    .clipShape(Circle())
                            }
                            .frame(maxWidth: .infinity)
                            .listRowBackground(Color.ColorSystem.systemBackground)
                        } else {
                            HStack {
                                VStack {
                                    Image(systemName: "person.circle.fill")
                                        .foregroundStyle(Color.ColorSystem.systemGray)
                                }
                                .frame(width: UIScreen.main.bounds.size.width / 2, height: UIScreen.main.bounds.size.width / 2)
                                .background(Color.ColorSystem.systemGray6)
                                .clipShape(Circle())
                            }
                            .frame(maxWidth: .infinity)
                            .listRowBackground(Color.ColorSystem.systemBackground)
                        }
                    }
                } footer: {
                    VStack {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(viewModel.user!.fullName)
                                .font(Font.FontStyles.title2)
                                .foregroundStyle(Color.ColorSystem.primaryText)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            if viewModel.user?.bio != nil {
                                Text(viewModel.user!.bio ?? "")
                                    .font(Font.FontStyles.body)
                                    .foregroundStyle(Color.ColorSystem.systemGray)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                    }
                    .frame(maxWidth: .infinity)
                    .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 16, trailing: 0))
                    .background(Color.ColorSystem.systemGray6)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
                // MARK: Content
                Section {
                    NavigationLink(value: NavigationDestinationTypes.UserProgramsView(userId: viewModel.user!.id)) {
                        HStack(spacing: 16) {
                            Image(systemName: "figure.run")
                                .frame(width: 20)
                                .foregroundStyle(Color.ColorSystem.primaryText)
                            
                            Text("Programs")
                                .font(Font.FontStyles.body)
                                .foregroundStyle(Color.ColorSystem.primaryText)
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .listRowBackground(Color.ColorSystem.systemGray6)
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(.insetGrouped)
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
