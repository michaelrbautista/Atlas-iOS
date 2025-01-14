//
//  SaveButton.swift
//  Atlas
//
//  Created by Michael Bautista on 12/6/24.
//

import SwiftUI

struct SaveButton: View {
    
    var viewModel: ProgramDetailViewModel
    
    @Binding var presentFinishProgram: Bool
    @Binding var presentStartProgram: Bool
    @Binding var presentPurchaseModal: Bool
    
    var body: some View {
        if viewModel.isPurchased {
            if viewModel.isStarted {
                // MARK: Started program
                Button {
                    presentFinishProgram.toggle()
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
        } else {
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
                    
                } label: {
                    HStack {
                        Spacer()
                        Text("Subscribers only")
                            .font(Font.FontStyles.headline)
                            .foregroundStyle(Color.ColorSystem.systemGray)
                        Spacer()
                    }
                    .padding(10)
                    .background(Color.ColorSystem.systemGray6)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                .listRowSeparator(.hidden)
            }
        }
    }
}

#Preview {
    SaveButton(viewModel: ProgramDetailViewModel(programId: ""), presentFinishProgram: .constant(false), presentStartProgram: .constant(false), presentPurchaseModal: .constant(false))
}
