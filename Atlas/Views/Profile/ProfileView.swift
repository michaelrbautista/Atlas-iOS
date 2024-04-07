//
//  ProfileView.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    // MARK: UI state
    @Environment(\.dismiss) private var dismiss
    
    @State var isSaving = false
    @State var isLoggingOut = false
    @FocusState var keyboardIsFocused: Bool
    @State var settingsIsPresented = false
    @State var editProfileIsPresented = false
    
    // MARK: Data
    @StateObject var viewModel = ProfileViewModel()
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        if viewModel.isLoading {
            VStack(alignment: .center) {
                Spacer()
                
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .tint(Color.ColorSystem.primaryText)
                
                Spacer()
            }
            .background(Color.ColorSystem.systemGray5)
        } else {
            NavigationStack {
                List {
                    Section {
                        VStack(spacing: 16) {
                            if viewModel.userImage != nil {
                                Image(uiImage: viewModel.userImage!)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: UIScreen.main.bounds.size.width / 2)
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: UIScreen.main.bounds.size.width / 2)
                                    .foregroundStyle(Color.ColorSystem.systemGray3)
                            }
                        }
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .listRowBackground(Color.ColorSystem.systemGray4)
                    } footer: {
                        VStack(alignment: .leading, spacing: 0) {
                            Text(viewModel.user?.fullName ?? "")
                                .font(Font.FontStyles.title1)
                                .foregroundStyle(Color.ColorSystem.primaryText)
                            
                            Text("@\(viewModel.user?.username ?? "")")
                                .font(Font.FontStyles.headline)
                                .foregroundStyle(Color.ColorSystem.secondaryText)
                        }
                        .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 16, trailing: 0))
                    }
                    
                    Section {
                        NavigationLink {
                            UserProgramsView(viewModel: UserProgramsViewModel(creatorUid: viewModel.user!.uid), isFromHomePage: false)
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "figure.run")
                                    .frame(width: 20)
                                    .foregroundStyle(Color.ColorSystem.primaryText)
                                
                                Text("My programs")
                                    .font(Font.FontStyles.body)
                                
                                Spacer()
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .listRowBackground(Color.ColorSystem.systemGray4)
                    }
                    
                    Section {
                        Button(action: {
                            
                        }, label: {
                            HStack {
                                Text("Edit profile")
                                    .foregroundStyle(Color.ColorSystem.secondaryText)
                                Spacer()
                            }
                        })
                        .listRowBackground(Color.ColorSystem.systemGray4)
                        .disabled(true)
                        
//                        Button(action: {
//                            
//                        }, label: {
//                            HStack {
//                                Text("Manage subscriptions (coming soon)")
//                                    .foregroundStyle(Color.ColorSystem.secondaryText)
//                                Spacer()
//                            }
//                        })
//                        .listRowBackground(Color.ColorSystem.systemGray4)
//                        .disabled(true)
                    }
                }
                .listStyle(.insetGrouped)
                .scrollContentBackground(.hidden)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Profile")
                .background(Color.ColorSystem.systemGray5)
                .toolbar(content: {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("", systemImage: "gearshape.fill") {
                            settingsIsPresented.toggle()
                        }
                    }
                })
            }
            .background(Color.ColorSystem.systemGray5)
            .sheet(isPresented: $settingsIsPresented, content: {
                SettingsView()
                    .presentationDetents([.medium])
            })
            .alert(isPresented: $viewModel.didReturnError, content: {
                Alert(title: Text(viewModel.returnedErrorMessage))
            })
        }
    }
}

#Preview {
    ProfileView()
}
