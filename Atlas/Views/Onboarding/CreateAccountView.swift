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
    
    @State private var isLoading = false
    
    @FocusState var keyboardIsFocused: Bool
    
    var body: some View {
        NavigationStack {
            List {
                // MARK: Image
                Section {
                    VStack {
                        // Add photo
                        if let image = viewModel.profilePicture {
                            PhotosPicker(selection: $viewModel.imageSelection, matching: .images) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: UIScreen.main.bounds.size.width / 2)
                                    .background(Color.ColorSystem.systemGray4)
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                    .foregroundStyle(Color.ColorSystem.secondaryText)
                            }
                            .buttonStyle(.plain)
                            .disabled(isLoading)
                        } else {
                            PhotosPicker(selection: $viewModel.imageSelection, matching: .images) {
                                Image(systemName: "camera.fill")
                                    .frame(maxWidth: .infinity)
                                    .frame(height: UIScreen.main.bounds.size.width / 2)
                                    .background(Color.ColorSystem.systemGray4)
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                    .foregroundStyle(Color.ColorSystem.secondaryText)
                            }
                            .buttonStyle(.plain)
                            .disabled(isLoading)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .listRowSeparator(.hidden)
                }
                
                // MARK: Full name
                Section {
                    TextField(text: $viewModel.fullName, prompt: Text("Full Name")) {
                        Text("Full Name")
                    }
                    .foregroundStyle(Color.ColorSystem.primaryText)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled(true)
                    .listRowBackground(Color.ColorSystem.systemGray4)
                    .disabled(isLoading)
                }
                
                // MARK: Email/username
                Section {
                    TextField(text: $viewModel.email, prompt: Text("Email")) {
                        Text("Email")
                    }
                    .foregroundStyle(Color.ColorSystem.primaryText)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .listRowBackground(Color.ColorSystem.systemGray4)
                    .disabled(isLoading)
                    
                    TextField(text: $viewModel.username, prompt: Text("Username")) {
                        Text("Username")
                    }
                    .foregroundStyle(Color.ColorSystem.primaryText)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .listRowBackground(Color.ColorSystem.systemGray4)
                    .disabled(isLoading)
                }
                
                // MARK: Password
                Section {
                    SecureField(text: $viewModel.password, prompt: Text("Password")) {
                        Text("Password")
                    }
                    .foregroundStyle(Color.ColorSystem.primaryText)
                    .listRowBackground(Color.ColorSystem.systemGray4)
                    .disabled(isLoading)
                    
                    SecureField(text: $viewModel.confirmPassword, prompt: Text("Confirm Password")) {
                        Text("Confirm Password")
                    }
                    .foregroundStyle(Color.ColorSystem.primaryText)
                    .listRowBackground(Color.ColorSystem.systemGray4)
                    .disabled(isLoading)
                }
                
                // MARK: Create account button
                Section {
                    Button(action: {
                        keyboardIsFocused = false
                        isLoading = true
                        
                        Task {
                            await viewModel.createUser { wasCreated, errorMessage, error in
                                if let error = error {
                                    viewModel.didReturnError = true
                                    viewModel.returnedErrorMessage = error.localizedDescription
                                    return
                                }
                                
                                if let errorMessage = errorMessage {
                                    viewModel.didReturnError = true
                                    viewModel.returnedErrorMessage = errorMessage
                                    return
                                }
                                
                                DispatchQueue.main.async {
                                    userViewModel.isLoggedIn = true
                                }
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
                                Text("Create Account")
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
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Create Account")
            .background(Color.ColorSystem.systemGray5)
            .alert(isPresented: $viewModel.didReturnError, content: {
                Alert(title: Text(viewModel.returnedErrorMessage ?? "Couldn't get workouts."))
            })
        }
    }
}

#Preview {
    CreateAccountView()
        .environmentObject(UserViewModel())
}
