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
            if let currentUser = UserService.currentUser {
                // MARK: User
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
                
                if currentUser.stripePriceId != nil {
                    // MARK: Creator
                    Section {
                        CoordinatorLink {
                            Text("My Programs")
                                .font(Font.FontStyles.body)
                                .foregroundStyle(Color.ColorSystem.primaryText)
                        } action: {
                            navigationController.push(.CreatorProgramsView)
                        }
                        
                        CoordinatorLink {
                            Text("My Workouts")
                                .font(Font.FontStyles.body)
                                .foregroundStyle(Color.ColorSystem.primaryText)
                        } action: {
                            navigationController.push(.CreatorWorkoutsView)
                        }
                        
                        CoordinatorLink {
                            Text("My Exercises")
                                .font(Font.FontStyles.body)
                                .foregroundStyle(Color.ColorSystem.primaryText)
                        } action: {
                            navigationController.push(.CreatorExercisesView)
                        }
                    } header: {
                        Text("Creator")
                    }
                }
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
