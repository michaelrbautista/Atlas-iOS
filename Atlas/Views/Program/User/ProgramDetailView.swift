//
//  ProgramDetailView.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI
import PhotosUI

struct ProgramDetailView: View {
    // MARK: Parameters
    @ObservedObject var viewModel: ProgramDetailViewModel
    var isCreator = false
    
    @Environment(\.dismiss) private var dismiss
    @FocusState var keyboardIsFocused: Bool
    
    @State var presentStartProgram = false
    @State var presentPurchaseModal = false
    @State var presentFinishProgram = false
    
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
            if let program = viewModel.program {
                List {
                    Section {
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
                        
                        if !isCreator {
                            VStack {
                                Text(program.isPrivate ? "Private" : "Public")
                            }
                            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                            .background(Color.ColorSystem.systemGray6)
                            .clipShape(RoundedRectangle(cornerRadius: 100))
                        }
                        
                        Spacer()
                    }
                    
                    // MARK: Save button
                    if !isCreator {
                        SaveButton(
                            viewModel: viewModel,
                            presentFinishProgram: $presentFinishProgram,
                            presentStartProgram: $presentStartProgram,
                            presentPurchaseModal: $presentPurchaseModal
                        )
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .navigationBarTitleDisplayMode(.inline)
                .background(Color.ColorSystem.systemBackground)
                .toolbar(content: {
                    if viewModel.isPurchased && viewModel.program!.free {
                        ToolbarItem(placement: .topBarTrailing) {
                            Menu {
                                Button {
                                    
                                } label: {
                                    Text("Unsave program")
                                }
                            } label: {
                                Image(systemName: "ellipsis")
                            }

                        }
                    }
                })
                .alert(isPresented: $viewModel.didReturnError, content: {
                    Alert(title: Text(viewModel.returnedErrorMessage))
                })
                .sheet(isPresented: $presentPurchaseModal) {
                    PurchaseModalView()
                        .presentationDetents([.height(200)])
                }
                .alert(Text("Are you sure you want to finish this program?"), isPresented: $presentFinishProgram) {
                    Button(role: .destructive) {
                        UserDefaults.standard.removeObject(forKey: "startedProgram")
                        UserDefaults.standard.removeObject(forKey: "startDayAsNumber")
                        UserDefaults.standard.removeObject(forKey: "startDate")
                        viewModel.isStarted = false
                    } label: {
                        Text("Yes")
                    }
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
    ProgramDetailView(viewModel: ProgramDetailViewModel(programId: "1941fa73-8ebd-43c4-8398-388908b99e07"), path: .constant([NavigationDestinationTypes]()))
}
