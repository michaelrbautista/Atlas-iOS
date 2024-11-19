//
//  ProgramsView.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI

struct ProgramsView: View {
    // MARK: UI State
    @State var presentSettings = false
    
    // MARK: Data
    @StateObject private var viewModel = ProgramsViewModel()
    
    @Binding var path: [NavigationDestinationTypes]
    
    var body: some View {
        List {
            Section {
                ForEach(viewModel.programs) { program in
                    ZStack {
                        if program.users != nil && program.programs != nil {
                            ProgramCell(title: program.programs!.title, imageUrl: program.programs!.imageUrl, userFullName: program.users!.fullName)
                            
                            NavigationLink(value: NavigationDestinationTypes.ProgramDetail(programId: program.programs!.id)) {
                                
                            }
                            .opacity(0)
                        }
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
                    .listRowSeparator(.hidden)
                }
                
                Color.ColorSystem.systemBackground
                    .frame(maxWidth: .infinity)
                    .frame(height: 16)
                    .padding(0)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .listRowSeparator(.hidden)
                
//                    if !viewModel.isLoading && !viewModel.endReached && viewModel.returnedErrorMessage == nil {
//                        ProgressView()
//                            .frame(maxWidth: .infinity)
//                            .frame(height: 48)
//                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0))
//                            .foregroundStyle(Color.ColorSystem.primaryText)
//                            .onAppear(perform: {
//                                // Get more programs
//                                Task {
//                                    await viewModel.getSavedPrograms()
//                                }
//                            })
//                    }
            }
        }
        .listStyle(.plain)
        .listRowSeparator(.hidden)
        .scrollContentBackground(.hidden)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Programs")
        .background(Color.ColorSystem.systemBackground)
        .refreshable(action: {
            await viewModel.pulledRefresh()
        })
        .alert(isPresented: $viewModel.didReturnError, content: {
            Alert(title: Text(viewModel.returnedErrorMessage))
        })
//        .navigationDestination(for: NavigationDestinationTypes.self, destination: { destination in
//            switch destination {
//            case .PostDetail:
//                let vm = PostDetailViewModel(post: destination.getPost())
//                PostDetailView(viewModel: vm)
//            case .UserDetail:
//                let vm = UserDetailViewModel(userId: destination.getId())
//                UserDetailView(viewModel: vm)
//            case .UserPrograms:
//                let vm = UserProgramsViewModel(userId: destination.getId())
//                UserProgramsView(viewModel: vm)
//            case .ProgramsView:
//                ProgramsView(path: $path)
//            case .ProgramDetail:
//                let vm = ProgramDetailViewModel(programId: destination.getId())
//                ProgramDetailView(viewModel: vm, path: $path)
//            case .CalendarView:
//                let program = destination.getProgram()
//                CalendarView(
//                    programId: program.id,
//                    weeks: program.weeks,
//                    pages: program.weeks / 4 + 1,
//                    remainder: program.weeks % 4
//                )
//            case .WorkoutDetail:
//                let vm = WorkoutDetailViewModel(workoutId: destination.getId())
//                WorkoutDetailView(viewModel: vm)
//            case .ExerciseDetail:
//                let vm = ExerciseDetailViewModel(workoutExercise: destination.getWorkoutExercise())
//                ExerciseDetailView(viewModel: vm)
//            }
//        })
    }
}

#Preview {
    ProgramsView(path: .constant([]))
        .environmentObject(UserViewModel())
}
