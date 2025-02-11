//
//  ProgramDetailView.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI

struct ProgramDetailView: View {
    @EnvironmentObject var navigationController: NavigationController
    @StateObject var viewModel: ProgramDetailViewModel
    
    // User
    @State var presentStartProgram = false
    @State var presentPurchaseModal = false
    @State var presentFinishProgram = false
    
    var removeProgram: (() -> Void)?
    
    var body: some View {
        if viewModel.isLoading {
            LoadingView()
                .onAppear {
                    Task {
                        await viewModel.getProgram()
                    }
                }
        } else if viewModel.didReturnError {
            ErrorView(errorMessage: viewModel.errorMessage)
        } else {
            if let program = viewModel.program {
                List {
                    VStack(spacing: 20) {
                        VStack(alignment: .center, spacing: 20) {
                            // MARK: Image
                            if program.imageUrl != nil {
                                if viewModel.programImage != nil {
                                    Image(uiImage: viewModel.programImage!)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 160, height: 160)
                                        .buttonStyle(.plain)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                } else {
                                    ProgressView()
                                        .frame(width: 160, height: 160)
                                        .tint(Color.ColorSystem.primaryText)
                                        .background(Color.ColorSystem.systemBackground)
                                        .buttonStyle(.plain)
                                }
                            } else {
                                VStack {
                                    Spacer()
                                    Image(systemName: "figure.run")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 32)
                                        .foregroundStyle(Color.ColorSystem.systemGray)
                                    Spacer()
                                }
                                .frame(width: 160, height: 160)
                                .background(Color.ColorSystem.systemGray6)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .buttonStyle(.plain)
                            }
                            
                            VStack {
                                // MARK: Title
                                Text(program.title)
                                    .font(Font.FontStyles.title3)
                                    .foregroundStyle(Color.ColorSystem.primaryText)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .multilineTextAlignment(.leading)
                                
                                // MARK: Creator
                                Text(program.createdBy!.fullName)
                                    .font(Font.FontStyles.subhead)
                                    .foregroundStyle(Color.ColorSystem.systemGray)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .multilineTextAlignment(.leading)
                                
                                // MARK: Description
                                if program.description != "" && program.description != nil {
                                    HStack {
                                        Text(program.description!)
                                        
                                        Spacer()
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
                                }
                            }
                        }
                        
                        // MARK: Badges
                        HStack {
                            VStack {
                                Text("\(program.weeks) weeks")
                            }
                            .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                            .background(Color.ColorSystem.systemGray6)
                            .clipShape(RoundedRectangle(cornerRadius: 100))
                            
                            VStack {
                                Text(program.free ? "Free" : "Paid")
                            }
                            .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                            .background(Color.ColorSystem.systemGray6)
                            .clipShape(RoundedRectangle(cornerRadius: 100))
                            
                            VStack {
                                Text(program.isPrivate ? "Private" : "Public")
                            }
                            .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                            .background(Color.ColorSystem.systemGray6)
                            .clipShape(RoundedRectangle(cornerRadius: 100))
                            
                            Spacer()
                        }
                        
                        // MARK: Calendar link
                        if viewModel.isSubscribed || viewModel.isPurchased || viewModel.program!.free || viewModel.isCreator {
                            Button {
                                navigationController.push(.CalendarView(program: viewModel.program!))
                            } label: {
                                HStack {
                                    HStack {
                                        Text("🗓️")
                                        
                                        Text("Calendar")
                                            .font(Font.FontStyles.headline)
                                            .foregroundStyle(Color.ColorSystem.primaryText)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 12)
                                        .foregroundStyle(Color.ColorSystem.systemGray2)
                                        .fontWeight(.bold)
                                }
                                .padding(10)
                                .background(Color.ColorSystem.systemGray6)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            .buttonStyle(.plain)
                            .listRowInsets(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.ColorSystem.systemBackground)
                        }
                        
                        // MARK: Save button
                        if !viewModel.isCreator {
                            SaveButton(
                                viewModel: viewModel,
                                isSaving: $viewModel.isSaving,
                                presentFinishProgram: $presentFinishProgram,
                                presentStartProgram: $presentStartProgram,
                                presentPurchaseModal: $presentPurchaseModal
                            )
                        }
                    }
                    .listRowInsets(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.ColorSystem.systemBackground)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .navigationBarTitleDisplayMode(.inline)
                .background(Color.ColorSystem.systemBackground)
                .toolbar(content: {
                    if viewModel.isPurchased {
                        ToolbarItem(placement: .topBarTrailing) {
                            Menu {
                                Button {
                                    Task {
                                        try await viewModel.unsaveProgram()
                                        
                                        self.removeProgram?()
                                        
                                        self.navigationController.pop()
                                    }
                                } label: {
                                    Text("Unsave program")
                                }
                            } label: {
                                Image(systemName: "ellipsis")
                            }
                        }
                    }
                })
                .alert(Text("Are you sure you want to finish this program?"), isPresented: $presentFinishProgram) {
                    Button(role: .destructive) {
                        viewModel.finishProgram()
                    } label: {
                        Text("Yes")
                    }
                }
                .sheet(isPresented: $presentPurchaseModal) {
                    PurchaseModalView()
                        .presentationDetents([.height(200)])
                }
                .sheet(isPresented: $presentStartProgram) {
                    StartProgramView(
                        isStarted: $viewModel.isStarted,
                        programId: viewModel.programId,
                        weeks: viewModel.program!.weeks,
                        pages: viewModel.program!.weeks / 4 + 1,
                        remainder: viewModel.program!.weeks % 4
                    )
                }
            }
        }
    }
}

#Preview {
    ProgramDetailView(viewModel: ProgramDetailViewModel(programId: "29683f2e-0da1-4eef-9666-09da010789e4"), removeProgram: {})
}
