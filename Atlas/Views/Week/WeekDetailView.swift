//
//  WeekDetailView.swift
//  Atlas
//
//  Created by Michael Bautista on 6/13/24.
//

import SwiftUI

struct WeekDetailView: View {
    @EnvironmentObject var programViewModel: ProgramDetailViewModel
    
    // MARK: UI State
    @State private var presentNewWorkout = false
    @State private var workoutDay: Day?
    
    @StateObject var viewModel: WeekDetailViewModel
    
    var body: some View {
        if viewModel.isLoading == true || viewModel.week == nil {
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
                if viewModel.week?.description != "" {
                    Section {
                        Text(viewModel.week!.description)
                            .listRowBackground(Color.ColorSystem.systemGray4)
                    } header: {
                        Text(viewModel.week!.title)
                            .font(Font.FontStyles.title1)
                    }
                    .headerProminence(.increased)
                } else {
                    Section {
                        Text(viewModel.week!.title)
                            .font(Font.FontStyles.title1)
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    }
                }
                
                // MARK: Monday
                Section {
                    ForEach(viewModel.week?.workouts?.filter({ $0.day == "monday" }) ?? [Workout]()) { workout in
                        NavigationLink {
                            WorkoutDetailView(viewModel: WorkoutDetailViewModel(workoutId: workout.id!))
                                .environmentObject(programViewModel)
                        } label: {
                            WorkoutCell(workoutTitle: workout.title)
                        }
                        .listRowBackground(Color.ColorSystem.systemGray4)
                    }
                    
                    if programViewModel.isCreator {
                        Button(action: {
                            workoutDay = Day.monday
                            presentNewWorkout.toggle()
                        }, label: {
                            Text("+ Add workout")
                                .foregroundStyle(Color.ColorSystem.secondaryText)
                        })
                        .listRowBackground(Color.ColorSystem.systemGray4)
                    }
                } header: {
                    Text("Monday")
                }
                
                // MARK: Tuesday
                Section {
                    ForEach(viewModel.week?.workouts?.filter({ $0.day == "tuesday" }) ?? [Workout]()) { workout in
                        NavigationLink {
                            WorkoutDetailView(viewModel: WorkoutDetailViewModel(workoutId: workout.id!))
                                .environmentObject(programViewModel)
                        } label: {
                            WorkoutCell(workoutTitle: workout.title)
                        }
                        .listRowBackground(Color.ColorSystem.systemGray4)
                    }
                    
                    if programViewModel.isCreator {
                        Button(action: {
                            workoutDay = Day.tuesday
                            presentNewWorkout.toggle()
                        }, label: {
                            Text("+ Add workout")
                                .foregroundStyle(Color.ColorSystem.secondaryText)
                        })
                        .listRowBackground(Color.ColorSystem.systemGray4)
                    }
                } header: {
                    Text("Tuesday")
                }
                
                // MARK: Wednesday
                Section {
                    ForEach(viewModel.week?.workouts?.filter({ $0.day == "wednesday" }) ?? [Workout]()) { workout in
                        NavigationLink {
                            WorkoutDetailView(viewModel: WorkoutDetailViewModel(workoutId: workout.id!))
                                .environmentObject(programViewModel)
                        } label: {
                            WorkoutCell(workoutTitle: workout.title)
                        }
                        .listRowBackground(Color.ColorSystem.systemGray4)
                    }
                    
                    if programViewModel.isCreator {
                        Button(action: {
                            workoutDay = Day.wednesday
                            presentNewWorkout.toggle()
                        }, label: {
                            Text("+ Add workout")
                                .foregroundStyle(Color.ColorSystem.secondaryText)
                        })
                        .listRowBackground(Color.ColorSystem.systemGray4)
                    }
                } header: {
                    Text("Wednesday")
                }
                
                // MARK: Thursday
                Section {
                    ForEach(viewModel.week?.workouts?.filter({ $0.day == "thursday" }) ?? [Workout]()) { workout in
                        NavigationLink {
                            WorkoutDetailView(viewModel: WorkoutDetailViewModel(workoutId: workout.id!))
                                .environmentObject(programViewModel)
                        } label: {
                            WorkoutCell(workoutTitle: workout.title)
                        }
                        .listRowBackground(Color.ColorSystem.systemGray4)
                    }
                    
                    if programViewModel.isCreator {
                        Button(action: {
                            workoutDay = Day.thursday
                            presentNewWorkout.toggle()
                        }, label: {
                            Text("+ Add workout")
                                .foregroundStyle(Color.ColorSystem.secondaryText)
                        })
                        .listRowBackground(Color.ColorSystem.systemGray4)
                    }
                } header: {
                    Text("Thursday")
                }
                
                // MARK: Friday
                Section {
                    ForEach(viewModel.week?.workouts?.filter({ $0.day == "friday" }) ?? [Workout]()) { workout in
                        NavigationLink {
                            WorkoutDetailView(viewModel: WorkoutDetailViewModel(workoutId: workout.id!))
                                .environmentObject(programViewModel)
                        } label: {
                            WorkoutCell(workoutTitle: workout.title)
                        }
                        .listRowBackground(Color.ColorSystem.systemGray4)
                    }
                    
                    if programViewModel.isCreator {
                        Button(action: {
                            workoutDay = Day.friday
                            presentNewWorkout.toggle()
                        }, label: {
                            Text("+ Add workout")
                                .foregroundStyle(Color.ColorSystem.secondaryText)
                        })
                        .listRowBackground(Color.ColorSystem.systemGray4)
                    }
                } header: {
                    Text("Friday")
                }
                
                // MARK: Saturday
                Section {
                    ForEach(viewModel.week?.workouts?.filter({ $0.day == "saturday" }) ?? [Workout]()) { workout in
                        NavigationLink {
                            WorkoutDetailView(viewModel: WorkoutDetailViewModel(workoutId: workout.id!))
                                .environmentObject(programViewModel)
                        } label: {
                            WorkoutCell(workoutTitle: workout.title)
                        }
                        .listRowBackground(Color.ColorSystem.systemGray4)
                    }
                    
                    if programViewModel.isCreator {
                        Button(action: {
                            workoutDay = Day.saturday
                            presentNewWorkout.toggle()
                        }, label: {
                            Text("+ Add workout")
                                .foregroundStyle(Color.ColorSystem.secondaryText)
                        })
                        .listRowBackground(Color.ColorSystem.systemGray4)
                    }
                } header: {
                    Text("Saturday")
                }
                
                // MARK: Sunday
                Section {
                    ForEach(viewModel.week?.workouts?.filter({ $0.day == "sunday" }) ?? [Workout]()) { workout in
                        NavigationLink {
                            WorkoutDetailView(viewModel: WorkoutDetailViewModel(workoutId: workout.id!))
                                .environmentObject(programViewModel)
                        } label: {
                            WorkoutCell(workoutTitle: workout.title)
                        }
                        .listRowBackground(Color.ColorSystem.systemGray4)
                    }
                    
                    if programViewModel.isCreator {
                        Button(action: {
                            workoutDay = Day.sunday
                            presentNewWorkout.toggle()
                        }, label: {
                            Text("+ Add workout")
                                .foregroundStyle(Color.ColorSystem.secondaryText)
                        })
                        .listRowBackground(Color.ColorSystem.systemGray4)
                    }
                } header: {
                    Text("Sunday")
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.ColorSystem.systemGray5)
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
//                    if UserService.currentUser?.id == viewModel.section?.createdBy {
//                        Menu("", systemImage: "ellipsis") {
//                            Button("Edit", role: .none) {
//                                presentEditSection.toggle()
//                            }
//                            
//                            Button("Delete", role: .destructive) {
//                                presentConfirmDelete.toggle()
//                            }
//                        }
//                    }
                }
            })
            .sheet(item: $workoutDay, content: { day in
                if let id = viewModel.week?.id {
                    NewWorkoutView(viewModel: NewWorkoutViewModel(weekId: id, day: day.description)) { workout in
                        viewModel.week?.workouts?.append(workout)
                    }
                }
            })
        }
    }
}

#Preview {
    WeekDetailView(viewModel: WeekDetailViewModel(weekId: "a71af994-f0fe-43ef-90b9-17f2d4972443"))
        .environmentObject(ProgramDetailViewModel(programId: "42c5486e-a1e3-42b4-b733-6331fef957bf"))
}
