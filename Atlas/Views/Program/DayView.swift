//
//  DayView.swift
//  Atlas
//
//  Created by Michael Bautista on 9/12/24.
//

import SwiftUI

struct DayView: View {
    
    // MARK: Data
    @ObservedObject var viewModel: DayViewModel
    
    var body: some View {
        if viewModel.workouts == nil || viewModel.isLoading {
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
                if viewModel.workouts!.count == 0 {
                    Text("No workouts")
                        .foregroundStyle(Color.ColorSystem.systemGray)
                } else {
                    ForEach(viewModel.workouts!) { workout in
                        ZStack {
                            WorkoutCell(
                                title: workout.title,
                                description: workout.description ?? ""
                            )
                            .background(Color.ColorSystem.systemGray6)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            NavigationLink(value: NavigationDestinationTypes.WorkoutDetail(workoutId: workout.id)) {
                                
                            }
                            .opacity(0)
                        }
                        .listRowInsets(EdgeInsets(top: 16, leading: 20, bottom: 0, trailing: 20))
                        .listRowSeparator(.hidden)
                    }
                }
            }
            .listStyle(.plain)
        }
    }
}

#Preview {
    DayView(viewModel: DayViewModel(programId: "b6619681-8e20-43f7-a67c-b6ed9750c731", week: 1, day: "monday"))
}
