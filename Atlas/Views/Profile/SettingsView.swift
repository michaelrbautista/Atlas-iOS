//
//  SettingsView.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI
import Supabase

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var userViewModel: UserViewModel
    
    @State var presentBecomeCreatorView = false
    
    @State var isLoading = false
    @State var confirmDeleteAccount = false
    
    @State var user: User
    
    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 4) {
                    Text(user.fullName)
                        .font(Font.FontStyles.title2)
                        .foregroundStyle(Color.ColorSystem.primaryText)
                    
                    Text("@\(user.username)")
                        .font(Font.FontStyles.headline)
                        .foregroundStyle(Color.ColorSystem.systemGray)
                }
                .listRowBackground(Color.ColorSystem.systemBackground)
                .listRowInsets(.none)
                .listRowSeparator(.hidden)
            }
            
            // MARK: Buttons
            Section {
                VStack(spacing: 16) {
                    // MARK: Logout
                    Button(action: {
                        isLoading = true
                        
                        Task {
                            do {
                                try await SupabaseService.shared.supabase.auth.signOut()
                                
                                DispatchQueue.main.async {
                                    self.userViewModel.isLoggedIn = false
                                }
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    }, label: {
                        if isLoading {
                            ProgressView()
                                .foregroundStyle(Color.ColorSystem.primaryText)
                        } else {
                            HStack {
                                Spacer()
                                Text("Logout")
                                    .font(Font.FontStyles.headline)
                                    .foregroundStyle(Color.ColorSystem.primaryText)
                                Spacer()
                            }
                        }
                    })
                    .buttonStyle(.plain)
                    .frame(maxWidth: .infinity)
                    .padding(12)
                    .background(Color.ColorSystem.systemGray6)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    // MARK: Delete account
                    Button(action: {
                        confirmDeleteAccount.toggle()
                    }, label: {
                        HStack {
                            Spacer()
                            Text("Delete account")
                                .font(Font.FontStyles.headline)
                                .foregroundStyle(Color.ColorSystem.primaryText)
                            Spacer()
                        }
                    })
                    .buttonStyle(.plain)
                    .frame(maxWidth: .infinity)
                    .padding(12)
                    .background(Color.ColorSystem.systemRed)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .listRowBackground(Color.ColorSystem.systemBackground)
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .background(Color.ColorSystem.systemBackground)
        .alert(Text("Are you sure you want to delete your account?"), isPresented: $confirmDeleteAccount) {
            Button(role: .destructive) {
                // Delete account
                Task {
                    do {
                        try await UserService.shared.deleteUser(uid: user.id)
                        
                        DispatchQueue.main.async {
                            self.userViewModel.isLoggedIn = false
                            
                            // Reset default screen user vs. creator
                            UserDefaults.standard.removeObject(forKey: "isCreatorView")
                        }
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Delete")
            }
        }
    }
}

#Preview {
    SettingsView(user: User(id: "", createdAt: "", email: "", fullName: "Test user", username: "testuser", paymentsEnabled: false))
        .environmentObject(UserViewModel())
}
