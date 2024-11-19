//
//  LoginView.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI
import Photos
import PhotosUI

struct LoginView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    
    @FocusState var keyboardIsFocused: Bool
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    @State private var isAlertShown = false
    @State private var alertMessage = ""
    
    @State private var isLoading = false
    
    var body: some View {
        List {
            Section {
                TextField("", text: $email, axis: .vertical)
                    .textInputAutocapitalization(.never)
                    .foregroundStyle(Color.ColorSystem.primaryText)
                    .listRowBackground(Color.ColorSystem.systemGray6)
                    .disabled(isLoading)
            } header: {
                Text("Email")
            }
            
            Section {
                SecureField(text: $password) {
                    Text("")
                }
                .textInputAutocapitalization(.never)
                .foregroundStyle(Color.ColorSystem.primaryText)
                .listRowBackground(Color.ColorSystem.systemGray6)
                .disabled(isLoading)
            } header: {
                Text("Password")
            }
            
            Section {
                Button(action: {
                    keyboardIsFocused = false
                    isLoading = true
                    
                    if email == "" || password == "" {
                        isLoading = false
                        isAlertShown = true
                        alertMessage = "Please fill in all fields."
                        return
                    }
                    
                    Task {
                        do {
                            try await SupabaseService.shared.supabase.auth.signIn(
                                email: email,
                                password: password
                            )
                            
                            let currentUserId = try await SupabaseService.shared.supabase.auth.session.user.id.description
                            
                            let user = try await UserService.shared.getUser(uid: currentUserId)
                            
                            UserService.currentUser = user
                            
                            userViewModel.isLoggedIn = true
                        } catch {
                            isLoading = false
                            isAlertShown = true
                            alertMessage = error.localizedDescription
                        }
                    }
                }, label: {
                    if isLoading {
                        HStack {
                            Spacer()
                            ProgressView()
                                .foregroundStyle(Color.ColorSystem.primaryText)
                            Spacer()
                        }
                    } else {
                        HStack {
                            Spacer()
                            Text("Login")
                                .font(Font.FontStyles.headline)
                            Spacer()
                        }
                    }
                })
                .disabled(isLoading)
                .foregroundStyle(Color.ColorSystem.primaryText)
                .listRowBackground(Color.ColorSystem.systemBlue)
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .scrollDismissesKeyboard(.interactively)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Login")
        .background(Color.ColorSystem.systemBackground)
        .alert("", isPresented: $isAlertShown) {
            
        } message: {
            Text(alertMessage)
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(UserViewModel())
}
