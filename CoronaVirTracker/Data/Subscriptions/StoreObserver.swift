//
//  StoreObserver.swift
//  CoronaVirTracker
//
//  Created by Vladyslav Baranov on 10.02.2023.
//  Copyright © 2023 CVTCompany. All rights reserved.
//

import StoreKit

final class StoreObserver: NSObject, SKPaymentTransactionObserver {
    
    static let shared = StoreObserver()
    
    func setCurrent(product id: String) {
        KeyStore.saveValue(id, for: .subscriptionID)
    }
    
    func isSubscribed() -> Bool {
        KeyStore.getStringValue(for: .subscriptionID) != nil
    }
    
    func dropSubscription() {
        KeyStore.dropValue(for: .subscriptionID)
    }
    
    var finishedCallback: (() -> ())?
    
    func buy(_ product: AppProduct) {
        guard SKPaymentQueue.canMakePayments() else { return }
        let payment = SKPayment(product: product.skProduct)
        SKPaymentQueue.default().add(payment)
    }
    
    func restore() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                break
            case .purchased:
                setCurrent(product: transaction.payment.productIdentifier)
                finishedCallback?()
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored:
                setCurrent(product: transaction.payment.productIdentifier)
                finishedCallback?()
                SKPaymentQueue.default().finishTransaction(transaction)
            case .deferred:
                break
            @unknown default:
                break
            }
        }
    }
    
    /*
    func receiptValidation(_ completion: @escaping (ValidationResponse?) -> ()) {
        
        #if DEBUG
        let verifyReceiptURL = "https://sandbox.itunes.apple.com/verifyReceipt"
        #else
        let verifyReceiptURL = "https://buy.itunes.apple.com/verifyReceipt"
        #endif
        
        let receiptFileURL = Bundle.main.appStoreReceiptURL
        let receiptData = try? Data(contentsOf: receiptFileURL!)
        guard let recieptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)) else {
            completion(nil)
            return
        }
        let jsonDict: [String: AnyObject] = [
            "receipt-data": recieptString as AnyObject,
            "password": "010fb4a4a6f24f088fe9820ba9acdc12" as AnyObject,
            "exclude-old-transactions": 1 as AnyObject
        ]
        
        do {
            let requestData = try JSONSerialization.data(withJSONObject: jsonDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            let storeURL = URL(string: verifyReceiptURL)!
            var storeRequest = URLRequest(url: storeURL)
            storeRequest.httpMethod = "POST"
            storeRequest.httpBody = requestData
            let session = URLSession(configuration: URLSessionConfiguration.default)
            let task = session.dataTask(
                with: storeRequest,
                completionHandler: { (data, response, error) in
                    if let data = data {
                        do {
                            if let jsonResponse = try JSONSerialization.jsonObject(
                                with: data,
                                options: JSONSerialization.ReadingOptions.mutableContainers
                            ) as? NSDictionary {
                                // print("Response :", jsonResponse)
                                let obj = ValidationResponse(jsonResponse)
                                completion(obj)
                            } else {
                                completion(nil)
                            }
                        } catch {
                            completion(nil)
                        }
                    } else {
                        completion(nil)
                    }
            })
            task.resume()
        } catch {
            completion(nil)
        }
    }
     */
}
