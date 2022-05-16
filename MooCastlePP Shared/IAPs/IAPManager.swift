//
//  IAPManager.swift
//  MooCastlePP iOS
//
//  Created by hehehe on 1/23/22.
//

import Foundation
import StoreKit

final class IAPManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    static let shared = IAPManager()
    var products = [SKProduct]()
    
    private var completion:((Int) -> Void)?
    
    enum Product: String, CaseIterable {
        case time1 = "com.MooCastlePP.time1"
        case time3 = "com.MooCastlePP.time3"
        case time5 = "com.MooCastlePP.time5"
        case time10 = "com.MooCastlePP.time10"
        case time20 = "com.MooCastlePP.time20"
        
        case sub1 = "com.MooCastlePP.subscription1"
        case sub2 = "com.MooCastlePP.subscription2"
        case sub3 = "com.MooCastlePP.subscription3"
        var count: Int {
            switch self {
            case .time1:
                return 1
            case .time3:
                return 3
            case .time5:
                return 5
            case .time10:
                return 12
            case .time20:
                return 25
            case .sub1:
                return 100
            case .sub2:
                return 101
            case .sub3:
                return 102
            }
        }
    }
    
    public func fetchProducts() {
        let request = SKProductsRequest(productIdentifiers: Set(Product.allCases.compactMap({ $0.rawValue})))
        request.delegate = self
        request.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
    }
    
    public func purchase(product: Product, completion: @escaping ((Int) -> Void)) {
        guard SKPaymentQueue.canMakePayments() else {
            return
        }
        guard let storeKitProduct = products.first(where: {$0.productIdentifier == product.rawValue}) else {
            return
        }
        self.completion = completion
        let paymentRequest = SKPayment(product: storeKitProduct)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(paymentRequest)
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach({
            switch $0.transactionState {
            case .purchasing:
                break
            case .purchased:
                if let product = Product(rawValue: $0.payment.productIdentifier) {
                    completion?(product.count)
                }
                SKPaymentQueue.default().finishTransaction($0)
                SKPaymentQueue.default().remove(self)
            case .failed:
                SKPaymentQueue.default().finishTransaction($0)
                SKPaymentQueue.default().remove(self)
//                fail(transaction: $0)
            case .restored:
                SKPaymentQueue.default().finishTransaction($0)
                SKPaymentQueue.default().remove(self)
            case .deferred:
                SKPaymentQueue.default().finishTransaction($0)
                SKPaymentQueue.default().remove(self)
            @unknown default:
                SKPaymentQueue.default().finishTransaction($0)
                SKPaymentQueue.default().remove(self)
            }
        })
    }
    
//    private func complete(transaction: SKPaymentTransaction) {
//      print("complete...")
//      deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier)
//      SKPaymentQueue.default().finishTransaction(transaction)
//    }
//   
//    private func restore(transaction: SKPaymentTransaction) {
//      guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
//   
//      print("restore... \(productIdentifier)")
//      deliverPurchaseNotificationFor(identifier: productIdentifier)
//      SKPaymentQueue.default().finishTransaction(transaction)
//    }
//   
//    private func fail(transaction: SKPaymentTransaction) {
//      print("fail...")
//      if let transactionError = transaction.error as NSError?,
//        let localizedDescription = transaction.error?.localizedDescription,
//          transactionError.code != SKError.paymentCancelled.rawValue {
//          print("Transaction Error: \(localizedDescription)")
//        }
//
//      SKPaymentQueue.default().finishTransaction(transaction)
//    }
//   
//    private func deliverPurchaseNotificationFor(identifier: String?) {
//      guard let identifier = identifier else { return }
//   
//      //purchasedProductIdentifiers.insert(identifier)
//      UserDefaults.standard.set(true, forKey: identifier)
//      NotificationCenter.default.post(name: .IAPHelperPurchaseNotification, object: identifier)
//    }
}
