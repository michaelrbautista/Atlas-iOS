//
//  DayView.swift
//  Atlas
//
//  Created by Michael Bautista on 9/12/24.
//

import SwiftUI

struct DayView: View {
    @EnvironmentObject var navigationController: NavigationController
    @ObservedObject var viewModel: DayViewModel
    
    var body: some View {
        Section {
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
                    .onAppear {
                        Task {
                            await viewModel.getWorkouts()
                        }
                    }
                } else if viewModel.workouts.count == 0 {
                    Text("No workouts.")
                        .font(Font.FontStyles.body)
                        .foregroundStyle(Color.ColorSystem.systemGray)
                } else {
                    ForEach(viewModel.workouts) { workout in
                        CoordinatorLink {
                            WorkoutCell(title: workout.title, description: workout.description)
                        } action: {
                            navigationController.push(.ProgramWorkoutDetailView(programWorkoutId: workout.id, deleteProgramWorkout: {
                                viewModel.workouts.remove(workout)
                            }))
                        }
                    }
                }
            }
            .listStyle(.plain)
        } header: {
            HStack {
                Text("Workouts")
                    .font(Font.FontStyles.title3)
                    .foregroundStyle(Color.ColorSystem.primaryText)
                
                Spacer()
                
                if viewModel.isCreator {
                    Button {
                        navigationController.presentSheet(.NewProgramWorkoutCoordinatorView(programId: viewModel.programId, week: viewModel.week, day: viewModel.day, addProgramWorkout: { newWorkout in
                            viewModel.workouts.insert(newWorkout, at: 0)
                        }))
                    } label: {
                        Image(systemName: "plus")
                    }
                    
                }
            }
            .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20))
        }
        .headerProminence(.increased)
    }
}

#Preview {
    DayView(viewModel: DayViewModel(programId: "b6619681-8e20-43f7-a67c-b6ed9750c731", isCreator: false, week: 1, day: "monday"))
}
