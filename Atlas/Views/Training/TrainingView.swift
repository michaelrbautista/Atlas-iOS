//
//  TrainingView.swift
//  Atlas
//
//  Created by Michael Bautista on 11/6/24.
//

import SwiftUI

struct TrainingView: View {
    @EnvironmentObject var navigationController: NavigationController
    @StateObject private var viewModel = TrainingViewModel()
    
    // MARK: UI State
    @State var presentSettings = false
    @State var presentCreateNutritionPlan = false
    @State var presentAddWorkout = false
    
    var body: some View {
        List {
            // MARK: Workouts
            Section {
                if viewModel.startedProgram != nil && viewModel.workouts != nil && !viewModel.isLoading {
                    if viewModel.workouts!.count == 0 {
                        Text("No workouts today.")
                            .foregroundStyle(Color.ColorSystem.systemGray)
                    } else {
                        ForEach(viewModel.workouts!) { workout in
                            CoordinatorLink {
                                WorkoutCell(title: workout.title, description: workout.description)
                            } action: {
                                navigationController.push(.ProgramWorkoutDetailView(programWorkoutId: workout.id, deleteProgramWorkout: {}))
                            }
                        }
                    }
                } else {
                    if !viewModel.isLoading {
                        HStack {
                            Text("You haven't started a program yet.")
                                .font(Font.FontStyles.headline)
                                .foregroundStyle(Color.ColorSystem.systemGray)
                                .padding(10)
                            
                            Spacer()
                        }
                        .background(Color.ColorSystem.systemGray6)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
                        .listRowSeparator(.hidden)
                    }
                }
            } header: {
                Text("Training")
                    .font(Font.FontStyles.title3)
                    .foregroundStyle(Color.ColorSystem.primaryText)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
            }
            
            #if DEBUG
            CoordinatorLink {
                Text("Test User")
            } action: {
                navigationController.push(.UserDetailView(userId: "e4d6f88c-d8c3-4a01-98d6-b5d56a366491"))
            }
            
            CoordinatorLink {
                Text("Article")
            } action: {
                navigationController.push(.ArticleDetailView(
                    article: Article(id: "a0b3cbb3-fff2-4ada-85b5-ffb40dfe0477", title: "Test for iOS", content: """
    {"type":"doc","content":[{"type":"bulletList","content":[{"type":"listItem","content":[{"type":"paragraph","content":[{"type":"text","marks":[{"type":"bold"}],"text":"Line"},{"type":"text","text":" one"}]}]},{"type":"listItem","content":[{"type":"paragraph","content":[{"type":"text","text":"Line "},{"type":"text","marks":[{"type":"italic"}],"text":"two"}]},{"type":"bulletList","content":[{"type":"listItem","content":[{"type":"paragraph","content":[{"type":"text","text":"Line three"}]},{"type":"bulletList","content":[{"type":"listItem","content":[{"type":"paragraph","content":[{"type":"text","text":"Line four"}]}]}]}]},{"type":"listItem","content":[{"type":"paragraph","content":[{"type":"text","text":"Line five"}]},{"type":"orderedList","attrs":{"start":1},"content":[{"type":"listItem","content":[{"type":"paragraph","content":[{"type":"text","text":"Line six"}]}]}]}]}]}]},{"type":"listItem","content":[{"type":"paragraph","content":[{"type":"text","text":"Line seven"}]}]}]},{"type":"paragraph"},{"type":"orderedList","attrs":{"start":1},"content":[{"type":"listItem","content":[{"type":"paragraph","content":[{"type":"text","text":"Line one"}]}]},{"type":"listItem","content":[{"type":"paragraph","content":[{"type":"text","marks":[{"type":"bold"}],"text":"Line"},{"type":"text","text":" two"}]},{"type":"bulletList","content":[{"type":"listItem","content":[{"type":"paragraph","content":[{"type":"text","text":"Line three"}]}]}]}]}]}]}
""", free: true, users: ArticleUser(id: "e4d6f88c-d8c3-4a01-98d6-b5d56a366491", fullName: "Test Seller", username: "testseller"))))
            }
            #endif
        }
        .listStyle(.plain)
        .listRowSeparator(.hidden)
        .scrollContentBackground(.hidden)
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle(Date.now.formatted(date: .abbreviated, time: .omitted))
        .background(Color.ColorSystem.systemBackground)
        .refreshable(action: {
            viewModel.refreshHome()
        })
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                Button("", systemImage: "person.circle.fill") {
                    presentSettings.toggle()
                }
                .tint(Color.ColorSystem.primaryText)
            }
        })
        .sheet(isPresented: $presentSettings, content: {
            if let currentUser = UserService.currentUser {
                SettingsView(user: currentUser)
            } else {
                Text("Couldn't get current user.")
            }
        })
        .alert(isPresented: $viewModel.didReturnError, content: {
            Alert(title: Text(viewModel.returnedErrorMessage))
        })
    }
}

#Preview {
    TrainingView()
        .environmentObject(UserViewModel())
}
