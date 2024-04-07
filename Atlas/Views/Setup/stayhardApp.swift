//
//  stayhardApp.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI
import Firebase
import FirebaseAuth

@main
struct stayhardApp: App {
    
    @StateObject var userViewModel = UserViewModel()
    
    init() {
        FirebaseApp.configure()
        
        let navAppearance = UINavigationBarAppearance()
        navAppearance.backgroundColor = UIColor(Color.ColorSystem.systemGray5)
        navAppearance.titleTextAttributes = [.foregroundColor: UIColor(Color.ColorSystem.primaryText)]
        navAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(Color.ColorSystem.primaryText)]
        navAppearance.shadowColor = .clear
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
        UINavigationBar.appearance().standardAppearance = navAppearance
        
        let tabAppearance = UITabBarAppearance()
        tabAppearance.backgroundColor = UIColor(Color.ColorSystem.systemGray5)
        tabAppearance.shadowColor = .clear
        UITabBar.appearance().scrollEdgeAppearance = tabAppearance
        UITabBar.appearance().standardAppearance = tabAppearance
    }
    
    var body: some Scene {
        WindowGroup {
            CheckAuthentication()
            .environmentObject(userViewModel)
        }
    }
}

struct CheckAuthentication: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        if userViewModel.isBusy {
            VStack {
                Spacer()
                
                ProgressView()
                    .frame(maxWidth: .infinity)
                
                Spacer()
            }
            .background(Color.ColorSystem.systemGray5)
            .tint(Color.ColorSystem.primaryText)
        } else {
            if userViewModel.isLoggedIn {
                ContentView()
                    .environmentObject(userViewModel)
            } else {
                LandingPageView()
                    .environmentObject(userViewModel)
            }
        }
    }
    
}

class UserViewModel: ObservableObject {
    @Published var isLoggedIn = false
    @Published var isBusy = false
    
    init() {
        self.isBusy = true
        
        Task {
            await checkAuth()
        }
    }
    
    public func checkAuth() async {
        DispatchQueue.main.async {
            self.isLoggedIn = false
            self.isBusy = true
        }
        
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                self.isLoggedIn = false
                self.isBusy = false
            }
        } else {
            await UserService.shared.getUser(uid: Auth.auth().currentUser!.uid) { user, error in
                if let error = error {
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        self.isLoggedIn = false
                        self.isBusy = false
                    }
                    return
                }
                
                UserService.currentUser = user
                
                DispatchQueue.main.async {
                    self.isLoggedIn = true
                    self.isBusy = false
                }
            }
        }
    }
}
