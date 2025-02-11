//
//  LibraryView.swift
//  Atlas
//
//  Created by Michael Bautista on 11/6/24.
//

import SwiftUI

struct LibraryView: View {
    @EnvironmentObject var navigationController: NavigationController
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        List {
            Section {
                CoordinatorLink {
                    Text("Subscriptions")
                        .font(Font.FontStyles.body)
                        .foregroundStyle(Color.ColorSystem.primaryText)
                } action: {
                    navigationController.push(.SubscriptionsView)
                }
                
                CoordinatorLink {
                    Text("Programs")
                        .font(Font.FontStyles.body)
                        .foregroundStyle(Color.ColorSystem.primaryText)
                } action: {
                    navigationController.push(.ProgramsView)
                }
            } header: {
                Text("User")
            }
        }
        .listStyle(.insetGrouped)
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle("Library")
    }
}

#Preview {
    LibraryView()
}
