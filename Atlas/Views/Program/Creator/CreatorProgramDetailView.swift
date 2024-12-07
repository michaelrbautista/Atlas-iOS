//
//  CreatorProgramDetailView.swift
//  Atlas
//
//  Created by Michael Bautista on 12/6/24.
//

import SwiftUI

struct CreatorProgramDetailView: View {
    @ObservedObject var viewModel: CreatorProgramDetailViewModel
    
    @Binding var path: [NavigationDestinationTypes]
    
    @State var presentEditProgram = false
    
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
            if let program = viewModel.program {
                List {
                    Section {
                        VStack(spacing: 20) {
                            HStack(alignment: .top, spacing: 10) {
                                // MARK: Image
                                if program.imageUrl != nil {
                                    if viewModel.programImage != nil {
                                        Image(uiImage: viewModel.programImage!)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .buttonStyle(.plain)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    } else {
                                        ProgressView()
                                            .frame(width: 100, height: 100)
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
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 200)
                                    .background(Color.ColorSystem.systemGray5)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .buttonStyle(.plain)
                                }
                                
                                Text(program.title)
                                    .font(Font.FontStyles.title3)
                                    .foregroundStyle(Color.ColorSystem.primaryText)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .multilineTextAlignment(.leading)
                            }
                            
                            // MARK: Description
                            if program.description != "" && program.description != nil {
                                Text(viewModel.program!.description!)
                            }
                            
                            // MARK: Badges
                            HStack {
                                VStack {
                                    Text("\(program.weeks) weeks")
                                }
                                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                                .background(Color.ColorSystem.systemGray6)
                                .clipShape(RoundedRectangle(cornerRadius: 100))
                                
                                VStack {
                                    Text("\(viewModel.program!.price.formatted(.currency(code: "usd")))")
                                }
                                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                                .background(Color.ColorSystem.systemGray6)
                                .clipShape(RoundedRectangle(cornerRadius: 100))
                                
                                VStack {
                                    Text(program.isPrivate ? "Private" : "Public")
                                }
                                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                                .background(Color.ColorSystem.systemGray6)
                                .clipShape(RoundedRectangle(cornerRadius: 100))
                                
                                Spacer()
                            }
                            
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
                                
                                NavigationLink(value: NavigationDestinationTypes.CalendarView(program: program)) {
                                    
                                }
                                .opacity(0)
                            }
                        }
                        .listRowInsets(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.ColorSystem.systemBackground)
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .navigationBarTitleDisplayMode(.inline)
                .background(Color.ColorSystem.systemBackground)
                .sheet(isPresented: $presentEditProgram, content: {
                    EditProgramView(viewModel: EditProgramViewModel(program: viewModel.program!, programImage: viewModel.programImage))
                })
                .toolbar(content: {
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu {
                            Button {
                                presentEditProgram.toggle()
                            } label: {
                                Text("Edit program")
                            }
                            
                            Button {
                                
                            } label: {
                                Text("Delete program")
                                    .foregroundStyle(Color.ColorSystem.systemRed)
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                        }
                    }
                })
                .alert(isPresented: $viewModel.didReturnError, content: {
                    Alert(title: Text(viewModel.returnedErrorMessage))
                })
            }
        }
    }
}

#Preview {
    CreatorProgramDetailView(viewModel: CreatorProgramDetailViewModel(programId: "1941fa73-8ebd-43c4-8398-388908b99e07"), path: .constant([]))
}
