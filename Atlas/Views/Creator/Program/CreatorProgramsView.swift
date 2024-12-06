//
//  CreatorProgramsView.swift
//  Atlas
//
//  Created by Michael Bautista on 12/5/24.
//

import SwiftUI

struct CreatorProgramsView: View {
    // MARK: Data
    @StateObject private var viewModel = CreatorProgramsViewModel()
    
    @Binding var path: [NavigationDestinationTypes]
    
    @State var presentNewProgram = false
    
    var body: some View {
        List {
            Section {
                ForEach(viewModel.programs) { program in
                    if let createdBy = program.createdBy {
                        NavigationLink(value: NavigationDestinationTypes.CreatorProgramDetailView(programId: program.id)) {
                            ProgramCell(title: program.title, imageUrl: program.imageUrl, userFullName: createdBy.fullName)
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
        .navigationTitle("My Programs")
        .background(Color.ColorSystem.systemBackground)
        .refreshable(action: {
            await viewModel.pulledRefresh()
        })
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button("", systemImage: "plus") {
                    presentNewProgram.toggle()
                }
            }
        })
        .sheet(isPresented: $presentNewProgram, content: {
            NewProgramView()
        })
        .alert(isPresented: $viewModel.didReturnError, content: {
            Alert(title: Text(viewModel.returnedErrorMessage))
        })
    }
}

#Preview {
    CreatorProgramsView(path: .constant([]))
}
