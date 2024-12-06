//
//  CreateAccountView.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI
import PhotosUI

struct CreateAccountView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @StateObject var viewModel = CreateAccountViewModel()
    
    @State var goToNextPage = false
    
    @State var isAlertShown = false
    @State var alertMessage = ""
    
    @FocusState var keyboardIsFocused: Bool
    
    var body: some View {
        List {
            // MARK: Full name
            Section {
                TextField("", text: $viewModel.fullName, axis: .vertical)
                    .textInputAutocapitalization(.words)
                    .foregroundStyle(Color.ColorSystem.primaryText)
                    .listRowBackground(Color.ColorSystem.systemGray6)
                    .disabled(viewModel.isSaving)
            } header: {
                Text("Full Name")
            }
            
            // MARK: Email
            Section {
                TextField("", text: $viewModel.email, axis: .vertical)
                    .textInputAutocapitalization(.never)
                    .foregroundStyle(Color.ColorSystem.primaryText)
                    .listRowBackground(Color.ColorSystem.systemGray6)
                    .disabled(viewModel.isSaving)
            } header: {
                Text("Email")
            }
            
            // MARK: Username
            Section {
                TextField("", text: $viewModel.username, axis: .vertical)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .foregroundStyle(Color.ColorSystem.primaryText)
                    .listRowBackground(Color.ColorSystem.systemGray6)
                    .disabled(viewModel.isSaving)
            } header: {
                Text("Username")
            }
            
            // MARK: Password
            Section {
                SecureField(text: $viewModel.password, prompt: Text("")) {
                    Text("Password")
                }
                .textInputAutocapitalization(.never)
                .foregroundStyle(Color.ColorSystem.primaryText)
                .listRowBackground(Color.ColorSystem.systemGray6)
                .disabled(viewModel.isSaving)
            } header: {
                Text("Password")
            }
            
            Section {
                SecureField(text: $viewModel.confirmPassword, prompt: Text("")) {
                    Text("Confirm password")
                }
                .textInputAutocapitalization(.never)
                .foregroundStyle(Color.ColorSystem.primaryText)
                .listRowBackground(Color.ColorSystem.systemGray6)
                .disabled(viewModel.isSaving)
            } header: {
                Text("Confirm Password")
            }
            
            // MARK: Create account button
            Section {
                Button(action: {
                    keyboardIsFocused = false
                    
                    Task {
                        await viewModel.createUser()
                        if viewModel.wasSuccessfullyCreated {
                            userViewModel.isLoggedIn = true
                        }
                    }
                }, label: {
                    if viewModel.isSaving {
                        HStack {
                            Spacer()
                            ProgressView()
                                .foregroundStyle(Color.ColorSystem.primaryText)
                            Spacer()
                        }
                    } else {
                        HStack {
                            Spacer()
                            Text("Create Account")
                                .font(Font.FontStyles.headline)
                            Spacer()
                        }
                    }
                })
                .disabled(viewModel.isSaving)
                .foregroundStyle(Color.ColorSystem.primaryText)
                .listRowBackground(Color.ColorSystem.systemBlue)
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .scrollDismissesKeyboard(.interactively)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Create Account")
        .background(Color.ColorSystem.systemBackground)
        .alert(isPresented: $viewModel.returnedError, content: {
            Alert(title: Text(viewModel.errorMessage ?? "Couldn't create account."))
        })
    }
}

#Preview {
    CreateAccountView()
        .environmentObject(UserViewModel())
}
