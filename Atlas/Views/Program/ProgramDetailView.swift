//
//  ProgramDetailView.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI
import PhotosUI

struct ProgramDetailView: View {
    // MARK: UI state
    @Environment(\.dismiss) private var dismiss
    @FocusState var keyboardIsFocused: Bool
    
    @State var presentStartProgram = false
    @State var presentPurchaseModal = false
    
    // MARK: Data
    @ObservedObject var viewModel: ProgramDetailViewModel
    
    @Binding var path: [NavigationDestinationTypes]
    
    var body: some View {
        if viewModel.program == nil || viewModel.isLoading {
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
            if let program = viewModel.program, let user = viewModel.program?.users {
                List {
                    Section {
                        VStack(spacing: 0) {
                            // MARK: Image
                            if program.imageUrl != nil {
                                if viewModel.programImage != nil {
                                    Image(uiImage: viewModel.programImage!)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(maxWidth: UIScreen.main.bounds.size.width)
                                        .frame(height: 200)
                                        .buttonStyle(.plain)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                } else {
                                    ProgressView()
                                        .frame(maxWidth: UIScreen.main.bounds.size.width)
                                        .frame(height: 200)
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
                                        .frame(height: 48)
                                        .foregroundStyle(Color.ColorSystem.systemGray)
                                    Spacer()
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 200)
                                .background(Color.ColorSystem.systemGray5)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .buttonStyle(.plain)
                            }
                            
                            Text(program.title)
                                .font(Font.FontStyles.title1)
                                .foregroundStyle(Color.ColorSystem.primaryText)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .multilineTextAlignment(.leading)
                                .padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
                            
                            // MARK: Team name
                            Button {
//                                path.append(NavigationDestinationTypes.TeamDetail(teamId: viewModel.team!.id))
                            } label: {
                                HStack {
                                    Text(user.fullName)
                                        .font(Font.FontStyles.headline)
                                        .foregroundStyle(Color.ColorSystem.systemBlue)
                                    Spacer()
                                }
                            }
                            .buttonStyle(.plain)
                        }
                        .listRowInsets(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                        .listRowSeparator(.hidden)
                    }
                    
                    // MARK: Description
                    if program.description != "" && program.description != nil {
                        Section {
                            HStack {
                                Text(viewModel.program!.description!)
                                    .padding(10)
                                
                                Spacer()
                            }
                            .background(Color.ColorSystem.systemGray6)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
                            .listRowSeparator(.hidden)
                        }
                    }
                    
                    if viewModel.isPurchased {
                        Section {
                            if viewModel.program!.free {
                                // MARK: Saved program
                                Button {
                                    Task {
                                        try await viewModel.unsaveProgram()
                                    }
                                } label: {
                                    HStack {
                                        Spacer()
                                        
                                        Text("Saved")
                                            .font(Font.FontStyles.headline)
                                            .foregroundStyle(Color.ColorSystem.systemGray)
                                        
                                        Spacer()
                                    }
                                    .padding(10)
                                    .background(Color.ColorSystem.systemGray5)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                                .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
                                .listRowSeparator(.hidden)
                                .disabled(true)
                            }
                            
                            if viewModel.isStarted {
                                // MARK: Started program
                                Button {
                                    
                                } label: {
                                    HStack {
                                        Spacer()
                                        
                                        Text("In Progress")
                                            .font(Font.FontStyles.headline)
                                            .foregroundStyle(Color.ColorSystem.systemGray)
                                        
                                        Spacer()
                                    }
                                    .padding(10)
                                    .background(Color.ColorSystem.systemGray5)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                                .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
                                .listRowSeparator(.hidden)
                                .disabled(true)
                            } else {
                                // MARK: Start program
                                Button {
                                    presentStartProgram.toggle()
                                } label: {
                                    HStack {
                                        Spacer()
                                        
                                        Text("Start Program")
                                            .font(Font.FontStyles.headline)
                                            .foregroundStyle(Color.ColorSystem.primaryText)
                                        
                                        Spacer()
                                    }
                                    .padding(10)
                                    .background(Color.ColorSystem.systemBlue)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                                .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
                                .listRowSeparator(.hidden)
                            }
                        }
                        
                        Section {
                            // MARK: Calendar link
                            ZStack {
                                HStack {
                                    HStack {
                                        Text("🗓️")
                                        
                                        Text("Calendar")
                                            .font(Font.FontStyles.headline)
                                            .foregroundStyle(Color.ColorSystem.primaryText)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(Color.ColorSystem.systemGray)
                                }
                                .padding(10)
                                .background(Color.ColorSystem.systemGray6)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                
                                NavigationLink(value: NavigationDestinationTypes.CalendarView(program: viewModel.program!)) {
                                    
                                }
                                .opacity(0)
                            }
                            .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
                            .listRowSeparator(.hidden)
                        }
                    } else {
                        Section {
                            // MARK: Save button
                            if viewModel.program!.free {
                                Button {
                                    Task {
                                        try await viewModel.saveProgram()
                                    }
                                } label: {
                                    HStack {
                                        Spacer()
                                        if viewModel.isSaving {
                                            ProgressView()
                                                .frame(maxWidth: UIScreen.main.bounds.size.width)
                                                .tint(Color.ColorSystem.primaryText)
                                        } else {
                                            Text("Save")
                                                .font(Font.FontStyles.headline)
                                                .foregroundStyle(Color.ColorSystem.primaryText)
                                        }
                                        Spacer()
                                    }
                                    .padding(10)
                                    .background(Color.ColorSystem.systemBlue)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                                .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                                .listRowSeparator(.hidden)
                            } else {
                                Button {
                                    presentPurchaseModal.toggle()
                                } label: {
                                    HStack {
                                        Spacer()
                                        Text("Purchase \(viewModel.program!.price.formatted(.currency(code: "usd")))")
                                            .font(Font.FontStyles.headline)
                                        Spacer()
                                    }
                                    .padding(10)
                                    .background(Color.ColorSystem.systemBlue)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                                .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                                .listRowSeparator(.hidden)
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .navigationBarTitleDisplayMode(.inline)
                .background(Color.ColorSystem.systemBackground)
                .alert(isPresented: $viewModel.didReturnError, content: {
                    Alert(title: Text(viewModel.returnedErrorMessage))
                })
                .sheet(isPresented: $presentPurchaseModal) {
                    PurchaseModalView()
                        .presentationDetents([.height(200)])
                }
                .sheet(isPresented: $presentStartProgram) {
                    StartProgramView(
                        programId: viewModel.program!.id,
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
    ProgramDetailView(viewModel: ProgramDetailViewModel(programId: "b6619681-8e20-43f7-a67c-b6ed9750c731"), path: .constant([NavigationDestinationTypes]()))
}
