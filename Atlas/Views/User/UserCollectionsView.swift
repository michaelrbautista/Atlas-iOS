//
//  UserCollectionsView.swift
//  Atlas
//
//  Created by Michael Bautista on 1/23/25.
//

import SwiftUI

struct UserCollectionsView: View {
    @EnvironmentObject var navigationController: NavigationController
    @StateObject var viewModel: UserCollectionsViewModel
    
    var body: some View {
        List {
            Section {
                ForEach(viewModel.collections) { collection in
                    CoordinatorLink {
                        WorkoutCell(title: collection.title, description: collection.description)
                    } action: {
                        navigationController.push(.CollectionDetailView(collectionId: collection.id))
                    }
                }
                
                if !viewModel.endReached && viewModel.returnedErrorMessage == "" {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0))
                        .onAppear(perform: {
                            Task {
                                await viewModel.getCreatorsCollections()
                            }
                        })
                }
            }
        }
        .listStyle(.plain)
        .listRowSeparator(.hidden)
        .scrollContentBackground(.hidden)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Collections")
        .background(Color.ColorSystem.systemBackground)
        .refreshable(action: {
            await viewModel.pulledRefresh()
        })
        .alert(isPresented: $viewModel.didReturnError, content: {
            Alert(title: Text(viewModel.returnedErrorMessage))
        })
    }
}

#Preview {
    UserCollectionsView(viewModel: UserCollectionsViewModel(userId: ""))
}
