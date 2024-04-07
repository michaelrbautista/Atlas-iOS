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
                VStack(spacing: 16) {
                    if viewModel.userImageIsLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .frame(height: UIScreen.main.bounds.size.width / 2)
                    } else {
                        Image(uiImage: viewModel.userImage!)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .frame(height: UIScreen.main.bounds.size.width / 2)
                    }
                }
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .listRowBackground(Color.ColorSystem.systemGray5)
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
                    UserProgramsView(viewModel: UserProgramsViewModel(creatorUid: "bTKT12UtFnN6nxciXaguP1BeW5B3"), isFromHomePage: true)
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
            ToolbarItem(placement: .topBarTrailing) {
                Button("", systemImage: "ellipsis") {
                    
                }
            }
        })
        .alert(isPresented: $viewModel.didReturnError, content: {
            Alert(title: Text(viewModel.returnedErrorMessage ?? ""))
        })
    }
}

#Preview {
    UserDetailView(viewModel: UserDetailViewModel(user: User(
        uid: "7VNj6cg8u7Ndo8JwG5KevruLpEh1",
        fullName: "Joe Schmo",
        fullNameLowercase: "joe schmo",
        userImageUrl: "https://firebasestorage.googleapis.com:443/v0/b/stayhard-9ef02.appspot.com/o/userImages%2F7VNj6cg8u7Ndo8JwG5KevruLpEh18210374283593336603.jpg?alt=media&token=5bbe5f03-b02a-4a33-8c22-a10acfa3e739",
        userImagePath: "userImages/7VNj6cg8u7Ndo8JwG5KevruLpEh18210374283593336603.jpg",
        username: "joeschmo",
        email: "joeschmo@email.com"
    )))
}
