//
//  UserDetailView.swift
//  stayhard
//
//  Created by Michael Bautista on 3/26/24.
//

import SwiftUI

struct UserDetailView: View {
    // MARK: UI state
    @Environment(\.dismiss) private var dismiss
    @FocusState var keyboardIsFocused: Bool
    
    // MARK: Data
    @StateObject var viewModel: UserDetailViewModel
    
    var body: some View {
        List {
            Section {
                if viewModel.profilePictureIsLoading {
                    HStack {
                        ProgressView()
                            .frame(width: UIScreen.main.bounds.size.width / 2, height: UIScreen.main.bounds.size.width / 2)
                            .clipShape(Circle())
                    }
                    .frame(maxWidth: .infinity)
                } else {
                    if viewModel.user.profilePictureUrl != nil {
                        HStack {
                            Image(uiImage: viewModel.profilePicture!)
                                .resizable()
                                .scaledToFill()
                                .frame(width: UIScreen.main.bounds.size.width / 2, height: UIScreen.main.bounds.size.width / 2)
                                .clipShape(Circle())
                        }
                        .frame(maxWidth: .infinity)
                    } else {
                        HStack {
                            VStack {
                                Image(systemName: "person.circle.fill")
                                    .foregroundStyle(Color.ColorSystem.secondaryText)
                            }
                            .frame(width: UIScreen.main.bounds.size.width / 2, height: UIScreen.main.bounds.size.width / 2)
                            .background(Color.ColorSystem.systemGray4)
                            .clipShape(Circle())
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            } footer: {
                VStack(alignment: .center, spacing: 0) {
                    Text(viewModel.user.fullName)
                        .font(Font.FontStyles.title1)
                        .foregroundStyle(Color.ColorSystem.primaryText)
                    
                    Text("@\(viewModel.user.username)")
                        .font(Font.FontStyles.headline)
                        .foregroundStyle(Color.ColorSystem.secondaryText)
                }
                .frame(maxWidth: .infinity)
                .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 16, trailing: 0))
            }
            
            Section {
                NavigationLink {
                    UserProgramsView(viewModel: UserProgramsViewModel(userId: "e7da8d24-3231-4759-be39-fb27ed2cff46"))
                } label: {
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
                .listRowBackground(Color.ColorSystem.systemGray4)
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(" ")
        .background(Color.ColorSystem.systemGray5)
        .toolbar(content: {
//            ToolbarItem(placement: .topBarTrailing) {
//                Button("", systemImage: "ellipsis") {
//                    
//                }
//            }
        })
        .alert(isPresented: $viewModel.didReturnError, content: {
            Alert(title: Text(viewModel.returnedErrorMessage ?? ""))
        })
    }
}

#Preview {
    UserDetailView(viewModel: UserDetailViewModel(user: User(id: "", email: "email", fullName: "Test User", username: "testuser", profilePictureUrl: "https://ltjnvfgpomlatmtqjxrk.supabase.co/storage/v1/object/public/profile_pictures/29DB3EDD-7700-4F60-B24B-F31A4B86AA06-5128345469385601134.jpg", isCreator: true)))
}
