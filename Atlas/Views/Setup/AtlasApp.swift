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
        #if DEBUG
        StripeAPI.defaultPublishableKey = "pk_test_51P3659KRUtiKYn5dqjDEIBTZQSxzvgLXlLwwP7qNzoBCvHt9fONoV1N6nLwkSDD5bGmfT1NyuWrIkd7yAhkLQpvS00ZY9EsKzQ"
        print()
        print("INITIALIZING ATLAS IN DEBUG MODE")
        #else
        StripeAPI.defaultPublishableKey = "pk_live_51P3659KRUtiKYn5dwsXjtLmId9RBxn7HcheF3xa7UUmIU9gB5muXSJ2O6QkzW4JXaA3KleatZqRpBLzWrKafaeNv007sERBIv3"
        #endif
        
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
            VStack(spacing: 16) {
                Spacer()
                
                ProgressView()
                    .frame(maxWidth: .infinity)
                
                Spacer()
            }
            .background(Color.ColorSystem.systemBackground)
            .tint(Color.ColorSystem.primaryText)
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
            
//            print(session)
            
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
