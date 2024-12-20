//
//  CreatorWorkoutsView.swift
//  Atlas
//
//  Created by Michael Bautista on 12/6/24.
//

import SwiftUI

struct CreatorWorkoutsView: View {
    // MARK: Data
    @StateObject private var viewModel = CreatorWorkoutsViewModel()
    
    @Binding var path: [RootNavigationTypes]
    
    @State var presentNewWorkout = false
    
    var body: some View {
        List {
            Section {
                ForEach(viewModel.workouts) { workout in
                    NavigationLink(value: RootNavigationTypes.LibraryWorkoutDetailView(workoutId: workout.id)) {
                        WorkoutCell(title: workout.title, description: workout.description)
                    }
                }
                
                Color.ColorSystem.systemBackground
                    .frame(maxWidth: .infinity)
                    .frame(height: 16)
                    .padding(0)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .listRowSeparator(.hidden)
                
                if !viewModel.isLoading && !viewModel.endReached && viewModel.returnedErrorMessage == "" {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0))
                        .foregroundStyle(Color.ColorSystem.primaryText)
                        .onAppear(perform: {
                            // Get more programs
                            Task {
                                await viewModel.getCreatorsPrograms()
                            }
                        })
                }
            }
        }
        .listStyle(.plain)
        .listRowSeparator(.hidden)
        .scrollContentBackground(.hidden)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("My Workouts")
        .background(Color.ColorSystem.systemBackground)
        .refreshable(action: {
            await viewModel.pulledRefresh()
        })
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button("", systemImage: "plus") {
                    presentNewWorkout.toggle()
                }
            }
        })
        .sheet(isPresented: $presentNewWorkout, content: {
            NewLibraryWorkoutView(
                addWorkout: { newWorkout in
                    viewModel.workouts.insert(newWorkout, at: 0)
                }
            )
        })
        .alert(isPresented: $viewModel.didReturnError, content: {
            Alert(title: Text(viewModel.returnedErrorMessage))
        })
    }
}

#Preview {
    CreatorWorkoutsView(path: .constant([]))
}
