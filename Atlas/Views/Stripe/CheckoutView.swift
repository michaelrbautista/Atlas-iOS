//
//  CheckoutView.swift
//  Atlas
//
//  Created by Michael Bautista on 6/15/24.
//

import SwiftUI
import StripePaymentSheet
import StripeApplePay

struct CheckoutView: View {
    @StateObject var viewModel: CheckoutViewModel
    
    var body: some View {
        List {
            Section {
                if let paymentSheet = viewModel.paymentSheet {
                    PaymentSheet.PaymentButton(
                        paymentSheet: paymentSheet,
                        onCompletion: viewModel.onPaymentCompletion
                    ) {
                        HStack {
                            Spacer()
                            
                            if viewModel.wasPurchased {
                                Text("Purchased")
                                    .font(Font.FontStyles.headline)
                                    .foregroundStyle(Color.ColorSystem.secondaryText)
                            } else {
                                Text("Buy Program")
                                    .font(Font.FontStyles.headline)
                                    .foregroundStyle(Color.ColorSystem.primaryText)
                            }
                            
                            Spacer()
                        }
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .listRowBackground(viewModel.wasPurchased ? Color.ColorSystem.systemGray4 : Color.ColorSystem.systemBlue)
                    .disabled(viewModel.wasPurchased)
                } else {
                    HStack {
                        Spacer()
                        ProgressView()
                            .foregroundStyle(Color.ColorSystem.primaryText)
                        Spacer()
                    }
                }
            }
            .onAppear {
                viewModel.preparePaymentSheet()
            }
                
            
            Section {
                if let result = viewModel.paymentResult {
                    switch result {
                    case .completed:
                        Text("Payment complete.")
                    case .failed(let error):
                        Text("Payment failed: \(error.localizedDescription)")
                    case .canceled:
                        Text("Payment canceled.")
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Checkout")
        .background(Color.ColorSystem.systemGray5)
    }
}

#Preview {
    CheckoutView(viewModel: CheckoutViewModel(program: Program(createdBy: "", title: "", description: "", category: "", price: "", currency: ""), creator: User(id: "", email: "", fullName: "", username: ""), onProgramPurchased: {}))
}
