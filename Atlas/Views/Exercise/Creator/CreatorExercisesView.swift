//
//  CreatorExercisesView.swift
//  Atlas
//
//  Created by Michael Bautista on 12/13/24.
//

import SwiftUI

struct CreatorExercisesView: View {
    // MARK: Data
    @StateObject private var viewModel = CreatorExercisesViewModel()
    
    @Binding var path: [RootNavigationTypes]
    
    @State var presentNewExercise = false
    
    var body: some View {
        List {
            Section {
                ForEach(viewModel.exercises) { exercise in
                    NavigationLink(value: RootNavigationTypes.LibraryExerciseDetailView(exercise: exercise)) {
                        VStack(spacing: 5) {
                            Text(exercise.title)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(Font.FontStyles.headline)
                                .foregroundStyle(Color.ColorSystem.primaryText)
                            
                            if exercise.instructions != nil {
                                Text(exercise.instructions!)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(Font.FontStyles.body)
                                    .foregroundStyle(Color.ColorSystem.systemGray)
                                    .lineLimit(2)
                            }
                        }
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
                                await viewModel.getCreatorsExercises()
                            }
                        })
                }
            }
        }
        .listStyle(.plain)
        .listRowSeparator(.hidden)
        .scrollContentBackground(.hidden)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("My Exercises")
        .background(Color.ColorSystem.systemBackground)
        .refreshable(action: {
            await viewModel.pulledRefresh()
        })
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button("", systemImage: "plus") {
                    presentNewExercise.toggle()
                }
            }
        })
        .sheet(isPresented: $presentNewExercise, content: {
            NewLibraryExerciseView { exercise in
                viewModel.exercises.insert(exercise, at: 0)
            }
        })
        .alert(isPresented: $viewModel.didReturnError, content: {
            Alert(title: Text(viewModel.returnedErrorMessage))
        })
    }
}

#Preview {
    CreatorExercisesView(path: .constant([]))
}
