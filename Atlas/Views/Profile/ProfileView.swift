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
    
    // MARK: Navigation path
    @State var path = NavigationPath()
    
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
                        HStack() {
                            Spacer()
                            if viewModel.user?.profilePictureUrl != nil {
                                if viewModel.profilePicture != nil {
                                    Image(uiImage: viewModel.profilePicture!)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: UIScreen.main.bounds.size.width / 2, height: UIScreen.main.bounds.size.width / 2 ,alignment: .center)
                                        .clipShape(Circle())
                                } else {
                                    ProgressView()
                                        .frame(width: UIScreen.main.bounds.size.width / 2, height: UIScreen.main.bounds.size.width / 2)
                                        .clipShape(Circle())
                                        .tint(Color.ColorSystem.primaryText)
                                }
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 48)
                                    .foregroundStyle(Color.ColorSystem.systemGray3)
                            }
                            Spacer()
                        }
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .listRowBackground(Color.ColorSystem.systemGray5)
                    } footer: {
                        VStack(alignment: .center, spacing: 0) {
                            Text(viewModel.user?.fullName ?? "")
                                .font(Font.FontStyles.title1)
                                .foregroundStyle(Color.ColorSystem.primaryText)
                            
                            Text("@\(viewModel.user?.username ?? "")")
                                .font(Font.FontStyles.headline)
                                .foregroundStyle(Color.ColorSystem.systemGray)
                        }
                        .frame(maxWidth: .infinity)
                        .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 16, trailing: 0))
                    }
                    
                    Section {
                        NavigationLink {
                            
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "figure.run")
                                    .frame(width: 20)
                                    .foregroundStyle(Color.ColorSystem.primaryText)
                                
                                Text("My Programs")
                                    .font(Font.FontStyles.body)
                                
                                Spacer()
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .listRowBackground(Color.ColorSystem.systemGray4)
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
                SettingsView(user: viewModel.user!)
                    .environmentObject(userViewModel)
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
