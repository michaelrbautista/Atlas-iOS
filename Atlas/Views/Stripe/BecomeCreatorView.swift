//
//  BecomeCreatorView.swift
//  Atlas
//
//  Created by Michael Bautista on 4/11/24.
//

import SwiftUI

struct BecomeCreatorView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    // MARK: UI State
    @EnvironmentObject var userViewModel: UserViewModel
    @StateObject var viewModel: BecomeCreatorViewModel
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(spacing: 16) {
                        Text("Become a creator with Stripe")
                            .font(Font.FontStyles.title1)
                            .foregroundStyle(Color.ColorSystem.primaryText)
                            .multilineTextAlignment(.center)
                        
                        Text("Monetize your fitness knowledge and grow your brand")
                            .font(Font.FontStyles.headline)
                            .foregroundStyle(Color.ColorSystem.primaryText)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: UIScreen.main.bounds.size.width - 64)
                    .listRowBackground(Color.ColorSystem.systemGray5)
                    .background(Color.ColorSystem.systemGray5)
                }
                
                Section {
                    Button(action: {
                        if UserService.currentUser!.stripeAccountId == nil {
                            Task {
                                await viewModel.createStripeAccount()
                            }
                        }
                    }, label: {
                        if viewModel.becomeCreatorisLoading {
                            HStack {
                                Spacer()
                                ProgressView()
                                    .foregroundStyle(Color.ColorSystem.primaryText)
                                Spacer()
                            }
                        } else {
                            HStack {
                                Spacer()
                                if UserService.currentUser!.stripeAccountId != nil {
                                    Link("Finish Onboarding", destination: URL(string: viewModel.accountLink)!)
                                        .font(Font.FontStyles.headline)
                                        .foregroundStyle(Color.ColorSystem.primaryText)
                                } else {
                                    Text("Create Stripe Account")
                                        .font(Font.FontStyles.headline)
                                        .foregroundStyle(Color.ColorSystem.primaryText)
                                }
                                Spacer()
                            }
                        }
                    })
                    .listRowBackground(Color.ColorSystem.systemBlue)
                    .onAppear(perform: {
                        if UserService.currentUser!.stripeAccountId != nil {
                            Task {
                                await viewModel.getAccountLink()
                            }
                        } else {
                            viewModel.becomeCreatorisLoading = false
                        }
                    })
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Color.ColorSystem.systemGray5)
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Text("Cancel")
                            .foregroundStyle(Color.ColorSystem.primaryText)
                    })
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        Task {
                            let chargesEnabled = await viewModel.checkChargesEnabled()
                            
                            userViewModel.stripeChargesEnabled = chargesEnabled
                        }
                        
                        dismiss()
                    }, label: {
                        if viewModel.doneIsLoading == true {
                            ProgressView()
                                .foregroundStyle(Color.ColorSystem.primaryText)
                        } else {
                            Text("Done")
                                .foregroundStyle(Color.ColorSystem.primaryText)
                        }
                    })
                }
            })
        }
    }
}

#Preview {
    BecomeCreatorView(viewModel: BecomeCreatorViewModel())
}
