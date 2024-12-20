//
//  LibraryView.swift
//  Atlas
//
//  Created by Michael Bautista on 11/6/24.
//

import SwiftUI

struct LibraryView: View {
    // MARK: Data
    @EnvironmentObject var userViewModel: UserViewModel
    
    @State var path = [RootNavigationTypes]()
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                if let currentUser = UserService.currentUser {
                    // MARK: User
                    Section {
                        NavigationLink(value: RootNavigationTypes.ProgramsView(userId: currentUser.id)) {
                            Text("Programs")
                        }
                    } header: {
                        Text("User")
                    }
                    
                    #if DEBUG
                    if currentUser.paymentsEnabled {
                        // MARK: Creator
                        Section {
                            NavigationLink(value: RootNavigationTypes.CreatorProgramsView(userId: currentUser.id)) {
                                Text("My Programs")
                            }
                            
                            NavigationLink(value: RootNavigationTypes.CreatorWorkoutsView(userId: currentUser.id)) {
                                Text("My Workouts")
                            }
                            
                            NavigationLink(value: RootNavigationTypes.CreatorExercisesView(userId: currentUser.id)) {
                                Text("My Exercises")
                            }
                        } header: {
                            Text("Creator")
                        }
                    }
                    #endif
                }
            }
            .listStyle(.insetGrouped)
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle("Library")
            .rootNavigationDestination(path: $path)
        }
    }
}

#Preview {
    LibraryView()
}
