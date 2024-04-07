//
//  ContentView.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                }
            
            WorkoutView()
                .tabItem {
                    Image(systemName: "figure.run")
                }
                .environmentObject(userViewModel)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                }
                .environmentObject(userViewModel)
        }
        .tint(Color.ColorSystem.primaryText)
    }
}

#Preview {
    ContentView()
        .environmentObject(UserViewModel())
}
