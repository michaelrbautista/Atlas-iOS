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
    @StateObject var viewModel: TeamDetailViewModel
    
    var body: some View {
        if viewModel.team == nil || viewModel.isLoading {
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
                    if viewModel.teamImageIsLoading {
                        HStack {
                            ProgressView()
                                .frame(width: UIScreen.main.bounds.size.width / 3, height: UIScreen.main.bounds.size.width / 3)
                                .clipShape(Circle())
                        }
                        .frame(maxWidth: .infinity)
                        .listRowBackground(Color.ColorSystem.systemBackground)
                    } else {
                        if viewModel.team?.imageUrl != nil {
                            HStack {
                                Image(uiImage: viewModel.teamImage!)
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
                            Text(viewModel.team!.name)
                                .font(Font.FontStyles.title2)
                                .foregroundStyle(Color.ColorSystem.primaryText)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text(viewModel.team!.description ?? "")
                                .font(Font.FontStyles.body)
                                .foregroundStyle(Color.ColorSystem.systemGray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                    }
                    .frame(maxWidth: .infinity)
                    .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 16, trailing: 0))
                    .background(Color.ColorSystem.systemGray6)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
                // MARK: Join team
                Section {
                    if viewModel.isJoined {
                        Button {
                            
                        } label: {
                            HStack {
                                Spacer()
                                if viewModel.isJoining {
                                    ProgressView()
                                        .frame(maxWidth: UIScreen.main.bounds.size.width)
                                        .tint(Color.ColorSystem.primaryText)
                                } else {
                                    Text("Joined")
                                        .font(Font.FontStyles.headline)
                                        .foregroundStyle(Color.ColorSystem.systemGray)
                                }
                                Spacer()
                            }
                        }
                        .listRowBackground(Color.ColorSystem.systemGray5)
                    } else {
                        Button {
                            Task {
                                await viewModel.joinTeam()
                            }
                        } label: {
                            HStack {
                                Spacer()
                                if viewModel.isJoining {
                                    ProgressView()
                                        .frame(maxWidth: UIScreen.main.bounds.size.width)
                                        .tint(Color.ColorSystem.primaryText)
                                } else {
                                    Text("Join Team")
                                        .font(Font.FontStyles.headline)
                                        .foregroundStyle(Color.ColorSystem.primaryText)
                                }
                                Spacer()
                            }
                        }
                        .listRowBackground(Color.ColorSystem.systemBlue)
                    }
                }
                
                // MARK: Programs
                Section {
                    NavigationLink(value: NavigationDestinationTypes.TeamPrograms(teamId: viewModel.team!.id)) {
                        HStack(spacing: 16) {
                            Image(systemName: "figure.run")
                                .frame(width: 20)
                                .foregroundStyle(Color.ColorSystem.primaryText)
                            
                            Text("Programs")
                                .font(Font.FontStyles.body)
                            
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
    TeamDetailView(viewModel: TeamDetailViewModel(teamId: "789507a5-4dd2-4371-996d-e85ae21e13a8"))
}
