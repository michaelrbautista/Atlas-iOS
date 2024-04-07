//
//  HomeView.swift
//  stayhard
//
//  Created by Michael Bautista on 3/26/24.
//

import SwiftUI

struct HomeView: View {
    // MARK: Data
    @StateObject private var viewModel = HomeViewModel(uid: "bTKT12UtFnN6nxciXaguP1BeW5B3")
    
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
                    ZStack {
                        UserCell(userImageUrl: viewModel.user?.userImageUrl ?? "", userFullName: viewModel.user?.fullName ?? "")
                        
                        NavigationLink {
                            UserDetailView(viewModel: UserDetailViewModel(user: viewModel.user))
                                .toolbarRole(.editor)
                        } label: {
                            EmptyView()
                        }
                        .opacity(0)
                    }
                    .listRowBackground(Color.ColorSystem.systemGray5)
                    .listRowSeparator(.hidden)
                    
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Home")
                .background(Color.ColorSystem.systemGray5)
            }
            .alert(isPresented: $viewModel.didReturnError, content: {
                Alert(title: Text(viewModel.returnedErrorMessage ?? ""))
            })
        }
    }
}

#Preview {
    HomeView()
}
