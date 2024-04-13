//
//  PaymentHandler.swift
//  Atlas
//
//  Created by Michael Bautista on 4/7/24.
//

import Foundation
import PassKit

typealias PaymentCompletionHandler = (Bool) -> Void

class PaymentHandler: NSObject {
    var paymentController: PKPaymentAuthorizationController?
    var paymentSummaryItem = PKPaymentSummaryItem()
    var paymentStatus = PKPaymentAuthorizationStatus.failure
    var completionHandler: PaymentCompletionHandler?
    
    static let supportedNetworks: [PKPaymentNetwork] = [
        .amex,
        .discover,
        .visa,
        .masterCard
    ]
    
    func startPayment(subscription: Subscription, completion: @escaping PaymentCompletionHandler) {
        completionHandler = completion
        
        paymentSummaryItem = PKPaymentSummaryItem(label: subscription.name, amount: NSDecimalNumber(string: "\(subscription.price).00"), type: .final)
        
        let paymentRequest = PKPaymentRequest()
        paymentRequest.paymentSummaryItems = [paymentSummaryItem]
        paymentRequest.merchantIdentifier = "merchant.michaelbautista.atlas"
        paymentRequest.merchantCapabilities = .threeDSecure
        paymentRequest.countryCode = "US"
        paymentRequest.currencyCode = "USD"
        paymentRequest.supportedNetworks = PaymentHandler.supportedNetworks
        
        paymentController = PKPaymentAuthorizationController(paymentRequest: paymentRequest)
        paymentController?.delegate = self
        paymentController?.present(completion: { (presented: Bool) in
            if presented {
                debugPrint("Presented payment controller")
            } else {
                debugPrint("Failed to present payment controller")
            }
        })
    }
}

extension PaymentHandler: PKPaymentAuthorizationControllerDelegate {
    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        let errors = [Error]()
        let status = PKPaymentAuthorizationStatus.success
        
        self.paymentStatus = status
        completion(PKPaymentAuthorizationResult(status: status, errors: errors))
    }
    
    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        DispatchQueue.main.async {
            if self.paymentStatus == .success {
                if let completionHandler = self.completionHandler {
                    completionHandler(true)
                }
            } else {
                if let completionHandler = self.completionHandler {
                    completionHandler(false)
                }
            }
        }
    }
}
