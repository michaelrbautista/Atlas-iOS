//
//  LibraryWorkoutsForProgramView.swift
//  Atlas
//
//  Created by Michael Bautista on 12/8/24.
//

import SwiftUI

struct LibraryWorkoutsForProgramView: View {
    
    @StateObject var viewModel: LibraryWorkoutsForProgramViewModel
    
    @Binding var path: [SheetNavigationTypes]
    
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
                    NavigationLink(value: SheetNavigationTypes.LibraryWorkoutDetailForProgramView(workoutId: workout.id, programId: viewModel.programId, week: viewModel.week, day: viewModel.day)) {
                        WorkoutCell(title: workout.title, description: workout.description)
                    }
                    .listRowBackground(Color.ColorSystem.systemBackground)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Library Workouts")
            .scrollContentBackground(.hidden)
            .background(Color.ColorSystem.systemBackground)
            .refreshable(action: {
                await viewModel.pulledRefresh()
            })
        }
    }
}

#Preview {
    LibraryWorkoutsForProgramView(viewModel: LibraryWorkoutsForProgramViewModel(programId: "", week: 9, day: ""), path: .constant([]))
}
