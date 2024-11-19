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
//            HomeView()
//                .tabItem {
//                    Image(systemName: "house.fill")
//                }
//                .environmentObject(userViewModel)
            
            TrainingView()
                .tabItem {
                    Image(systemName: "figure.run")
                }
                .environmentObject(userViewModel)
            
            ExploreView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
                .environmentObject(userViewModel)
            
//            TrainingView()
//                .tabItem {
//                    Image(systemName: "figure.run")
//                }
//                .environmentObject(userViewModel)
            
            LibraryView()
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
