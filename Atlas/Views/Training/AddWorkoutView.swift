//
//  AddWorkoutView.swift
//  Atlas
//
//  Created by Michael Bautista on 11/10/24.
//

import SwiftUI

struct AddWorkoutView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var viewModel = AddWorkoutViewModel()
    
    var addWorkoutToTotal: ((HealthKitWorkout) -> Void)?
    
    var body: some View {
        List {
            Section {
                ForEach(Array(viewModel.workouts.enumerated()), id: \.offset) { index, workout in
                    HKWorkoutCell(workout: workout)
                        .listRowBackground(Color.ColorSystem.systemBackground)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
                        .onTapGesture {
                            addWorkoutToTotal?(workout)
                            dismiss()
                        }
                }
            } header: {
                VStack(alignment: .leading) {
                    Text("Workouts")
                        .font(Font.FontStyles.title3)
                        .foregroundStyle(Color.ColorSystem.primaryText)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    
                    Text("These workouts are imported from apple.")
                        .font(Font.FontStyles.footnote)
                        .foregroundStyle(Color.ColorSystem.systemGray)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .listStyle(.plain)
        .background(Color.ColorSystem.systemBackground)
    }
}

#Preview {
    AddWorkoutView()
}
