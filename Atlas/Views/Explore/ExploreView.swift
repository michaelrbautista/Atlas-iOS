//
//  ExploreView.swift
//  Atlas
//
//  Created by Michael Bautista on 10/4/24.
//

import SwiftUI

struct ExploreView: View {
    
    // MARK: Data
    @EnvironmentObject var userViewModel: UserViewModel
    @StateObject private var viewModel = ExploreViewModel()
    
    @State var path = [NavigationDestinationTypes]()
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
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
                    if viewModel.searchText != "" {
                        if viewModel.filter == "Programs" {
                            ForEach(viewModel.programs) { program in
                                NavigationLink(value: NavigationDestinationTypes.ProgramDetail(programId: program.id)) {
                                    SearchProgramCell(program: program)
                                }
                            }
                        } else {
                            ForEach(viewModel.users) { user in
                                NavigationLink(value: NavigationDestinationTypes.UserDetail(userId: user.id)) {
                                    SearchUserCell(user: user)
                                }
                            }
                        }
                    }
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Explore")
            .background(Color.ColorSystem.systemBackground)
            .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always))
            .onSubmit(of: .search, {
                Task {
                    await viewModel.search()
                }
            })
            .alert(isPresented: $viewModel.didReturnError, content: {
                Alert(title: Text(viewModel.returnedErrorMessage))
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

#Preview {
    ExploreView()
}
