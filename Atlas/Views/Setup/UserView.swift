//
//  UserView.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI

struct UserView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        TabView {
            TrainingCoordinatorView()
                .tabItem {
                    Image(systemName: "figure.run")
                }
                .environmentObject(userViewModel)
            
            ExploreCoordinatorView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
                .environmentObject(userViewModel)
            
            LibraryCoordinatorView()
                .tabItem {
                    Image(systemName: "text.book.closed.fill")
                }
                .environmentObject(userViewModel)
        }
        .tint(Color.ColorSystem.primaryText)
    }
}

#Preview {
    UserView()
        .environmentObject(UserViewModel())
}
