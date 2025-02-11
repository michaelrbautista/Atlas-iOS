//
//  NavigationViews.swift
//  Atlas
//
//  Created by Michael Bautista on 2/11/25.
//

import SwiftUI

struct TrainingCoordinatorView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    @StateObject var navigationController: NavigationController = NavigationController()
    
    var body: some View {
        NavigationStack(path: $navigationController.path) {
            navigationController.build(.TrainingView)
                .environmentObject(userViewModel)
                .navigationDestination(for: Screen.self) { screen in
                    navigationController.build(screen)
                }
                .sheet(item: $navigationController.sheet) { sheet in
                    navigationController.build(sheet)
                }
                .fullScreenCover(item: $navigationController.fullScreenCover) { fullScreenCover in
                    navigationController.build(fullScreenCover)
                }
        }
        .environmentObject(navigationController)
    }
}

struct ExploreCoordinatorView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    @StateObject var navigationController: NavigationController = NavigationController()
    
    var body: some View {
        NavigationStack(path: $navigationController.path) {
            navigationController.build(.ExploreView)
                .environmentObject(userViewModel)
                .navigationDestination(for: Screen.self) { screen in
                    navigationController.build(screen)
                }
                .sheet(item: $navigationController.sheet) { sheet in
                    navigationController.build(sheet)
                }
                .fullScreenCover(item: $navigationController.fullScreenCover) { fullScreenCover in
                    navigationController.build(fullScreenCover)
                }
        }
        .environmentObject(navigationController)
    }
}

struct LibraryCoordinatorView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    @StateObject var navigationController: NavigationController = NavigationController()
    
    var body: some View {
        NavigationStack(path: $navigationController.path) {
            navigationController.build(.LibraryView)
                .environmentObject(userViewModel)
                .navigationDestination(for: Screen.self) { screen in
                    navigationController.build(screen)
                }
                .sheet(item: $navigationController.sheet) { sheet in
                    navigationController.build(sheet)
                }
                .fullScreenCover(item: $navigationController.fullScreenCover) { fullScreenCover in
                    navigationController.build(fullScreenCover)
                }
        }
        .environmentObject(navigationController)
    }
}
