//
//  LibraryWorkoutsForProgramView.swift
//  Atlas
//
//  Created by Michael Bautista on 12/8/24.
//

import SwiftUI

struct LibraryWorkoutsForProgramView: View {
    @EnvironmentObject var navigationController: NavigationController
    @EnvironmentObject var sheetNavigationController: SheetNavigationController
    @StateObject var viewModel: LibraryWorkoutsForProgramViewModel
    
    var addWorkoutToProgram: ((ProgramWorkout) -> Void)
    
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
            List {
                ForEach(viewModel.workouts) { workout in
                    CoordinatorLink {
                        WorkoutCell(title: workout.title, description: workout.description)
                    } action: {
                        sheetNavigationController.push(.LibraryWorkoutDetailForProgramView(workoutId: workout.id, programId: viewModel.programId, week: viewModel.week, day: viewModel.day, addWorkoutToProgram: { newWorkout in
                            
                        }))
                    }
                    .listRowBackground(Color.ColorSystem.systemBackground)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Library Workouts")
            .background(Color.ColorSystem.systemBackground)
            .refreshable(action: {
                await viewModel.pulledRefresh()
            })
        }
    }
}

#Preview {
    LibraryWorkoutsForProgramView(viewModel: LibraryWorkoutsForProgramViewModel(programId: "", week: 9, day: ""), addWorkoutToProgram: {_ in})
}
