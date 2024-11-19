//
//  LandingPageView.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI

struct LandingPageView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(spacing: 8) {
                        Spacer()
                        
                        Image(systemName: "figure.run")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 64)
                            .foregroundStyle(Color.ColorSystem.primaryText)
                        Image(systemName: "fork.knife")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 64)
                            .foregroundStyle(Color.ColorSystem.primaryText)
                        
                        Spacer()
                    }
                    .padding(EdgeInsets(top: 180, leading: 0, bottom: 120, trailing: 0))
                    .listRowBackground(Color.ColorSystem.systemBackground)
                    .listRowSeparator(.hidden)
                }
                
                Section {
                    ZStack {
                        Text("Login")
                            .frame(maxWidth: .infinity)
                            .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
                            .font(Font.FontStyles.headline)
                            .background(Color.ColorSystem.systemGray6)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        NavigationLink {
                            LoginView()
                                .environmentObject(userViewModel)
                        } label: {
                            EmptyView()
                        }
                        .opacity(0)
                    }
                    .listRowBackground(Color.ColorSystem.systemBackground)
                    .listRowSeparator(.hidden)
                    
                    ZStack {
                        Text("Create Account")
                            .frame(maxWidth: .infinity)
                            .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
                            .font(Font.FontStyles.headline)
                            .background(Color.ColorSystem.systemBlue)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        NavigationLink {
                            CreateAccountView()
                                .environmentObject(userViewModel)
                        } label: {
                            EmptyView()
                        }
                        .opacity(0)
                    }
                    .listRowBackground(Color.ColorSystem.systemBackground)
                    .listRowSeparator(.hidden)
                }
            }
            .scrollDisabled(true)
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color.ColorSystem.systemBackground)
        }
    }
}

#Preview {
    LandingPageView()
        .environmentObject(UserViewModel())
}
