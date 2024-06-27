//
//  ProgramSectionDetailView.swift
//  Atlas
//
//  Created by Michael Bautista on 6/13/24.
//

import SwiftUI

struct ProgramSectionDetailView: View {
    @EnvironmentObject var programViewModel: ProgramDetailViewModel
    
    // MARK: UI State
    @State private var presentNewWorkout = false
    @State private var presentEditSection = false
    
    @StateObject var viewModel: ProgramSectionDetailViewModel
    
    var body: some View {
        if viewModel.sectionIsLoading == true || viewModel.section == nil {
            VStack(alignment: .center) {
                Spacer()
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .tint(Color.ColorSystem.primaryText)
                Spacer()
            }
            .background(Color.ColorSystem.systemGray5)
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $viewModel.didReturnError, content: {
                Alert(title: Text(viewModel.returnedErrorMessage))
            })
        } else {
            List {
                // MARK: Description
                if viewModel.section?.description != "" {
                    Section {
                        Text(viewModel.section!.description)
                            .listRowBackground(Color.ColorSystem.systemGray4)
                    } header: {
                        Text(viewModel.section!.title)
                            .font(Font.FontStyles.title1)
                    }
                    .headerProminence(.increased)
                } else {
                    Section {
                        Text(viewModel.section!.title)
                            .font(Font.FontStyles.title1)
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    }
                }
                
                // MARK: Workouts
                Section {
                    ForEach(viewModel.section!.workouts ?? [Workout]()) { workout in
                        NavigationLink {
                            WorkoutDetailView(viewModel: WorkoutDetailViewModel(workoutId: workout.id!))
                                .environmentObject(programViewModel)
                        } label: {
                            WorkoutCell(workoutTitle: workout.title)
                        }
                        .listRowBackground(Color.ColorSystem.systemGray4)
                        .disabled(!programViewModel.programIsPurchased && !workout.isFree && !programViewModel.isCreator)
                    }
                    
                    if programViewModel.program!.createdBy == UserService.currentUser?.id {
                        Button(action: {
                            presentNewWorkout.toggle()
                        }, label: {
                            Text("+ Add workout")
                                .foregroundStyle(Color.ColorSystem.systemBlue)
                        })
                        .listRowBackground(Color.ColorSystem.systemGray4)
                    }
                } header: {
                    Text("Workouts")
                        .foregroundStyle(Color.ColorSystem.primaryText)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
                .headerProminence(.increased)
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.ColorSystem.systemGray5)
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    if UserService.currentUser?.id == viewModel.section?.createdBy {
                        Menu("", systemImage: "ellipsis") {
                            Button("Edit", role: .none) {
                                presentEditSection.toggle()
                            }
                            
//                            Button("Delete", role: .destructive) {
//                                presentConfirmDelete.toggle()
//                            }
                        }
                    }
                }
            })
            .sheet(isPresented: $presentNewWorkout, content: {
                NewWorkoutView(viewModel: NewWorkoutViewModel(sectionId: viewModel.section!.id!, workoutNumber: (viewModel.section?.workouts?.count ?? 0) + 1)) { workout in
                    viewModel.section?.workouts?.append(workout)
                }
            })
            // MARK: Edit section
        }
    }
}

#Preview {
    ProgramSectionDetailView(viewModel: ProgramSectionDetailViewModel(sectionId: ""))
        .environmentObject(ProgramDetailViewModel(programId: ""))
}
