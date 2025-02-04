//
//  AtlasApp.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI
import Supabase
import StripePaymentsUI

@main
struct AtlasApp: App {
    
    @StateObject var userViewModel = UserViewModel()
    
    init() {
        let navAppearance = UINavigationBarAppearance()
        navAppearance.backgroundColor = UIColor(Color.ColorSystem.systemBackground)
        navAppearance.titleTextAttributes = [.foregroundColor: UIColor(Color.ColorSystem.primaryText)]
        navAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(Color.ColorSystem.primaryText)]
        navAppearance.shadowColor = .clear
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
        UINavigationBar.appearance().standardAppearance = navAppearance
        
        let tabAppearance = UITabBarAppearance()
        tabAppearance.backgroundColor = UIColor(Color.ColorSystem.systemBackground)
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
            LoadingView()
        } else {
            if userViewModel.isLoggedIn {
                UserView()
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
    
    @Published var event: AuthChangeEvent? = nil
    @Published var session: Session? = nil
    
    init() {
        self.isBusy = true
        
        Task {
            await checkAuth()
        }
    }
    
    @MainActor
    public func checkAuth() async {
        self.isBusy = true
        
        do {
            let _ = try await SupabaseService.shared.supabase.auth.session
            
            let authUser = try await SupabaseService.shared.supabase.auth.session.user
            
            let user: User = try await SupabaseService.shared.supabase
                .from("users")
                .select()
                .eq("id", value: authUser.id)
                .single()
                .execute()
                .value
            
            UserService.currentUser = user
            
            isLoggedIn = true
            isBusy = false
        } catch {
            print(error)
            isLoggedIn = false
            isBusy = false
        }
    }
}
