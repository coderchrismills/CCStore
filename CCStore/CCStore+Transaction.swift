//
//  CCStore+Transaction.swift
//  CCStore
//
//  Created by Chris on 12/10/18.
//  Copyright © 2018 Chris. All rights reserved.
//

import Foundation
import StoreKit

extension CCStore {
    func recordTransaction(_ transaction : SKPaymentTransaction) {
        let receiptURL = Bundle.main.appStoreReceiptURL
        let receipt = try? Data(contentsOf: receiptURL!)
        let skProductIdentifier = transaction.payment.productIdentifier
        self.products[skProductIdentifier]?.record(receipt: receipt)
    }
    
    func finishTransaction(_ transaction : SKPaymentTransaction, successful wasSuccessful : Bool) {
        SKPaymentQueue.default().finishTransaction(transaction)
        let userInfo = ["transaction" : transaction]
        if wasSuccessful {
            NotificationCenter.default.post(name: CCStoreNotification.kIAPTransactionSucceeded, object:self, userInfo: userInfo)
        }
        else {
            NotificationCenter.default.post(name: CCStoreNotification.kIAPTransactionFailed, object: self, userInfo:userInfo)
        }
    }
    
    func completeTransaction(_ transaction : SKPaymentTransaction) {
        recordTransaction(transaction)
        products[transaction.payment.productIdentifier]?.onPurchaseComplete?()
    }
    
    func restoreTransaction(_ transaction : SKPaymentTransaction) {
        recordTransaction(transaction.original!)
        products[transaction.payment.productIdentifier]?.onPurchaseComplete?()
    }
    
    func failedTransaction(_ transaction : SKPaymentTransaction) {
        if let error = transaction.error as? SKError {
            if error.code != SKError.paymentCancelled {
                finishTransaction(transaction, successful: false)
            }
            else {
                SKPaymentQueue.default().finishTransaction(transaction)
            }
        }
    }
}
