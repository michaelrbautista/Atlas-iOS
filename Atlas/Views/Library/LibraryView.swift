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
    
    @State var path = [NavigationDestinationTypes]()
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                Section {
                    if let currentUserId = UserService.currentUser?.id {
                        NavigationLink(value: NavigationDestinationTypes.ProgramsView(userId: currentUserId)) {
                            Text("Programs")
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle("Library")
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
    LibraryView()
}
