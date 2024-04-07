//
//  LoginView.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import Photos
import PhotosUI
import FirebaseStorage

struct LoginView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    @FocusState var keyboardIsFocused: Bool
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    @State private var isAlertShown = false
    @State private var alertMessage = ""
    
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField(text: $email, prompt: Text("Email")) {
                        Text("Email")
                    }
                    .foregroundStyle(Color.ColorSystem.primaryText)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .listRowBackground(Color.ColorSystem.systemGray4)
                    .disabled(isLoading)
                    
                    SecureField(text: $password) {
                        Text("Password")
                    }
                    .foregroundStyle(Color.ColorSystem.primaryText)
                    .textInputAutocapitalization(.never)
                    .listRowBackground(Color.ColorSystem.systemGray4)
                    .disabled(isLoading)
                }
                
                Section {
                    Button(action: {
                        keyboardIsFocused = false
                        isLoading = true
                        
                        AuthService.shared.signIn(email: email, password: password) { error in
                            isLoading = false
                            
                            if let error = error {
                                isAlertShown = true
                                alertMessage = error.localizedDescription
                                return
                            }
                            
                            DispatchQueue.main.async {
                                userViewModel.isLoggedIn = true
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
            .scrollDisabled(true)
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Login")
            .background(Color.ColorSystem.systemGray5)
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(UserViewModel())
}
