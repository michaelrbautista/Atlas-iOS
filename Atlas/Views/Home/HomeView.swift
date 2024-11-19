//
//  HomeView.swift
//  stayhard
//
//  Created by Michael Bautista on 3/26/24.
//

import SwiftUI

struct HomeView: View {
    // MARK: Data
    @EnvironmentObject var userViewModel: UserViewModel
    
    @StateObject var viewModel = HomeViewModel()
    
    @State var presentSettings = false
    
    @State var path = [NavigationDestinationTypes]()
    
    var body: some View {
        if viewModel.isLoading {
            VStack(alignment: .center) {
                Spacer()
                ProgressView()
                    .frame(maxWidth: UIScreen.main.bounds.size.width)
                    .tint(Color.ColorSystem.primaryText)
                Spacer()
            }
            .background(Color.ColorSystem.systemBackground)
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $viewModel.didReturnError, content: {
                Alert(title: Text(viewModel.returnedErrorMessage))
            })
        } else {
            NavigationStack(path: $path) {
                List {
                    ForEach(viewModel.posts) { post in
                        ZStack {
                            PostCell(post: post)
                            
                            NavigationLink(value: NavigationDestinationTypes.PostDetail(post: post)) {
                                
                            }
                            .opacity(0)
                        }
                    }
                    
                    if !viewModel.isLoading && !viewModel.endReached && viewModel.returnedErrorMessage == "" {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0))
                            .foregroundStyle(Color.ColorSystem.primaryText)
                            .onAppear(perform: {
                                // Get more programs
                                Task {
                                    await viewModel.getPosts()
                                }
                            })
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .navigationBarTitleDisplayMode(.inline)
//                .navigationTitle(Date.now.formatted(date: .abbreviated, time: .omitted))
                .navigationTitle("Home")
                .background(Color.ColorSystem.systemBackground)
                .refreshable {
//                    viewModel.refreshHome()
                }
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
                .navigationDestination(for: NavigationDestinationTypes.self, destination: { destination in
                    switch destination {
                    case .PostsView:
                        let vm = UserPostsViewModel(userId: destination.getId())
                        UserPostsView(viewModel: vm)
                    case .PostDetail:
                        let vm = PostDetailViewModel(post: destination.getPost())
                        PostDetailView(viewModel: vm)
                    case .UserDetail:
                        let vm = UserDetailViewModel(userId: destination.getId())
                        UserDetailView(viewModel: vm)
                    case .UserPrograms:
                        let vm = UserProgramsViewModel(userId: destination.getId())
                        UserProgramsView(viewModel: vm)
                    case .ProgramsView:
                        ProgramsView(path: $path)
                    case .ProgramDetail:
                        let vm = ProgramDetailViewModel(programId: destination.getId())
                        ProgramDetailView(viewModel: vm, path: $path)
                    case .CalendarView:
                        let program = destination.getProgram()
                        CalendarView(
                            programId: program.id,
                            weeks: program.weeks,
                            pages: program.weeks / 4 + 1,
                            remainder: program.weeks % 4
                        )
                    case .WorkoutDetail:
                        let vm = WorkoutDetailViewModel(workoutId: destination.getId())
                        WorkoutDetailView(viewModel: vm)
                    case .ExerciseDetail:
                        let vm = ExerciseDetailViewModel(workoutExercise: destination.getWorkoutExercise())
                        ExerciseDetailView(viewModel: vm)
                    }
                })
            }
        }
    }
}

#Preview {
    HomeView()
}
