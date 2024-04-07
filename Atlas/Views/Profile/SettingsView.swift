//
//  SettingsView.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var userViewModel: UserViewModel
    
    @State var isLoggingOut = false
    
    var body: some View {
        List {
            Section {
                Button(action: {
                    isLoggingOut = true
                    
                    AuthService.shared.signOut { error in
                        isLoggingOut = false
                        
                        if let error = error {
                            print(error.localizedDescription)
                            return
                        }
                        
                        dismiss()
                        userViewModel.isLoggedIn = false
                    }
                }, label: {
                    HStack(spacing: 16) {
                        Spacer()
                        
                        if isLoggingOut {
                            ProgressView()
                                .foregroundStyle(Color.ColorSystem.primaryText)
                        } else {
                            Text("Logout")
                                .font(Font.FontStyles.headline)
                                .foregroundStyle(Color.ColorSystem.primaryText)
                        }
                        
                        Spacer()
                    }
                })
                .frame(maxWidth: .infinity)
                .font(Font.FontStyles.headline)
                .listRowBackground(Color.ColorSystem.systemGray4)
            }
        }
        .listStyle(.insetGrouped)
        .background(Color.ColorSystem.systemGray5)
    }
}

#Preview {
    SettingsView()
}
