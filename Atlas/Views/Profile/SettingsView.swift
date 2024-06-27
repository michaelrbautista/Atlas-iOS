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
                        .foregroundStyle(Color.ColorSystem.secondaryText)
                }
                .listRowBackground(Color.ColorSystem.systemGray5)
                .listRowInsets(.none)
                .listRowSeparator(.hidden)
            }
            
            // MARK: Switch view
            Section {
                VStack(spacing: 16) {
                    if user.stripeAccountId != nil {
                        if userViewModel.isCreatorView {
                            // MARK: User view
                            Button(action: {
                                dismiss()
                                userViewModel.isCreatorView.toggle()
                                UserDefaults.standard.set(false, forKey: "isCreatorView")
                            }, label: {
                                HStack {
                                    Spacer()
                                    Text("Switch to user view")
                                        .font(Font.FontStyles.headline)
                                        .foregroundStyle(Color.ColorSystem.primaryText)
                                    Spacer()
                                }
                            })
                            .buttonStyle(.plain)
                            .frame(maxWidth: .infinity)
                            .padding(12)
                            .background(Color.ColorSystem.systemGray3)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        } else {
                            // MARK: Creator view
                            Button(action: {
                                dismiss()
                                userViewModel.isCreatorView.toggle()
                                UserDefaults.standard.set(true, forKey: "isCreatorView")
                            }, label: {
                                HStack {
                                    Spacer()
                                    Text("Switch to creator view")
                                        .font(Font.FontStyles.headline)
                                        .foregroundStyle(Color.ColorSystem.primaryText)
                                    Spacer()
                                }
                            })
                            .buttonStyle(.plain)
                            .frame(maxWidth: .infinity)
                            .padding(12)
                            .background(Color.ColorSystem.systemGray3)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    } else {
                        if userViewModel.isCreatorView {
                            // MARK: User View
                            Button(action: {
                                presentBecomeCreatorView.toggle()
                            }, label: {
                                HStack {
                                    Spacer()
                                    Text("Switch to user view")
                                        .font(Font.FontStyles.headline)
                                        .foregroundStyle(Color.ColorSystem.primaryText)
                                    Spacer()
                                }
                            })
                            .buttonStyle(.plain)
                            .frame(maxWidth: .infinity)
                            .padding(12)
                            .background(Color.ColorSystem.systemGray3)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .disabled(true)
                        } else {
                            // MARK: Become creator
                            Button(action: {
                                presentBecomeCreatorView.toggle()
                            }, label: {
                                HStack {
                                    Spacer()
                                    Text("Become a creator")
                                        .font(Font.FontStyles.headline)
                                        .foregroundStyle(Color.ColorSystem.primaryText)
                                    Spacer()
                                }
                            })
                            .buttonStyle(.plain)
                            .frame(maxWidth: .infinity)
                            .padding(12)
                            .background(Color.ColorSystem.systemGray3)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    
                    // MARK: Logout
                    Button(action: {
                        isLoading = true
                        
                        Task {
                            do {
                                try await supabase.auth.signOut()
                                
                                DispatchQueue.main.async {
                                    self.userViewModel.isLoggedIn = false
                                    self.userViewModel.isCreatorView = false
                                    
                                    // Reset default screen user vs. creator
                                    UserDefaults.standard.removeObject(forKey: "isCreatorView")
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
                    .background(Color.ColorSystem.systemGray3)
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
                .listRowBackground(Color.ColorSystem.systemGray5)
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .background(Color.ColorSystem.systemGray5)
        .sheet(isPresented: $presentBecomeCreatorView, content: {
            BecomeCreatorView(viewModel: BecomeCreatorViewModel())
        })
        .alert(Text("Are you sure you want to delete your account?"), isPresented: $confirmDeleteAccount) {
            Button(role: .destructive) {
                // Delete account
                Task {
                    do {
                        try await UserService.shared.deleteUser(uid: user.id)
                        
                        DispatchQueue.main.async {
                            self.userViewModel.isLoggedIn = false
                            self.userViewModel.isCreatorView = false
                            
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
    SettingsView(user: User(id: "", createdAt: "", email: "", fullName: "Test user", username: "testuser", stripeDetailsSubmitted: false))
        .environmentObject(UserViewModel())
}
