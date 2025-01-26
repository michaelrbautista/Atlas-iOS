//
//  CollectionDetailView.swift
//  Atlas
//
//  Created by Michael Bautista on 1/23/25.
//

import SwiftUI

struct CollectionDetailView: View {
    @EnvironmentObject var navigationController: NavigationController
    @StateObject var viewModel: CollectionDetailViewModel
    
    var body: some View {
        if viewModel.isLoading == true || viewModel.collection == nil {
            VStack(alignment: .center) {
                Spacer()
                ProgressView()
                    .frame(maxWidth: .infinity)
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
                    await viewModel.getCollection()
                }
            }
        } else {
            List {
                VStack {
                    // MARK: Title
                    Text(viewModel.collection!.title)
                        .font(Font.FontStyles.title1)
                        .foregroundStyle(Color.ColorSystem.primaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                    
                    // MARK: Description
                    if viewModel.collection?.description != "" && viewModel.collection?.description != nil {
                        HStack {
                            Text(viewModel.collection!.description!)
                                .font(Font.FontStyles.body)
                                .foregroundStyle(Color.ColorSystem.systemGray)
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .listRowSeparator(.hidden)
                
                // MARK: Articles
                if let articles = viewModel.collection?.articles {
                    if articles.count > 0 {
                        Section {
                            ForEach(articles) { article in
                                if let createdBy = article.users {
                                    CoordinatorLink {
                                        ArticleCell(
                                            title: article.title,
                                            imageUrl: article.imageUrl,
                                            userFullName: createdBy.fullName
                                        )
                                    } action: {
                                        navigationController.push(.ArticleDetailView(article: article))
                                    }
                                }
                            }
                        } header: {
                            HStack {
                                Text("Articles")
                                    .font(Font.FontStyles.title2)
                                    .foregroundStyle(Color.ColorSystem.primaryText)
                                
                                Spacer()
                            }
                        }
                        .headerProminence(.increased)
                    }
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.ColorSystem.systemBackground)
        }
    }
}

#Preview {
    CollectionDetailView(viewModel: CollectionDetailViewModel(collectionId: ""))
}
