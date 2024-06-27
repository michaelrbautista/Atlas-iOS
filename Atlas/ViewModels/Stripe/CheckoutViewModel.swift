//
//  CheckoutViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 6/15/24.
//

import SwiftUI
import StripePaymentSheet
import PassKit

class CheckoutViewModel: ObservableObject {
    let backendCheckoutUrl = URL(string: "https://expressserver-yffd.onrender.com/payment/paymentSheet")!
    @Published var paymentSheet: PaymentSheet?
    @Published var paymentResult: PaymentSheetResult?
    
    @Published var wasPurchased = false
    
    var program: Program
    var creator: User
    
    var onProgramPurchased: (() -> Void)?
    
    init(program: Program, creator: User, onProgramPurchased: (() -> Void)?) {
        self.program = program
        self.creator = creator
        self.onProgramPurchased = onProgramPurchased
    }
    
    func preparePaymentSheet() {
        // MARK: Fetch the PaymentIntent and Customer information from the backend
        var request = URLRequest(url: backendCheckoutUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let destinationAccountId = creator.stripeAccountId else {
            print("Couldn't get creator stripe id")
            return
        }
        
        let body: [String: Any] = [
            "amount": Decimal(string: program.price)! * 100,
            "destinationAccountId": destinationAccountId
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                  let paymentIntentClientSecret = json["paymentIntent"] as? String,
                  let publishableKey = json["publishableKey"] as? String,
                  let self = self else {
                // Handle error
                print("Error getting payment intent.")
                return
            }
            
            STPAPIClient.shared.publishableKey = publishableKey
            // MARK: Create a PaymentSheet instance
            var configuration = PaymentSheet.Configuration()
            configuration.merchantDisplayName = "Atlas"
            // Set `allowsDelayedPaymentMethods` to true if your business handles
            // delayed notification payment methods like US bank accounts.
            configuration.allowsDelayedPaymentMethods = true
            configuration.applePay = .init(
                merchantId: "merchant.michaelbautista.atlas",
                merchantCountryCode: "US"
            )
            
            DispatchQueue.main.async {
                self.paymentSheet = PaymentSheet(paymentIntentClientSecret: paymentIntentClientSecret, configuration: configuration)
            }
        })
        task.resume()
    }
    
    func onPaymentCompletion(result: PaymentSheetResult) {
        self.paymentResult = result
        
        switch result {
        case .completed:
            Task {
                do {
                    try await ProgramService.shared.saveProgram(program: program)
                    
                    DispatchQueue.main.async {
                        self.wasPurchased = true
                        self.onProgramPurchased?()
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        default:
            break
        }
    }
}
