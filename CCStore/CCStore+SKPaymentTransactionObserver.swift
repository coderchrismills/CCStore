//
//  CCStore+SKPaymentTransactionObserver.swift
//  CCStore
//
//  Created by Chris on 12/10/18.
//  Copyright © 2018 Chris. All rights reserved.
//

import Foundation
import StoreKit

extension CCStore {
    func processDownload(_ download : SKDownload) {
        numberOfDownloads -= 1;
        if numberOfDownloads < 1 {
            NotificationCenter.default.post(name: CCStoreNotification.kIAPProductsDownloadDidFinish, object: self)
            finishTransaction(download.transaction, successful: true)
        }
    }
}

extension CCStore: SKPaymentTransactionObserver {
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased :
                completeTransaction(transaction)
                break;
            case .failed :
                failedTransaction(transaction)
                break;
            case .restored :
                if(productsIdentifiersToRestore.contains(transaction.payment.productIdentifier)) {
                    restoreTransaction(transaction)
                }
                else {
                    SKPaymentQueue.default().finishTransaction(transaction)
                }
                break;
            default :
                break;
            }
            
            if transaction.downloads.count > 0 {
                SKPaymentQueue.default().start(transaction.downloads)
            }
        }
    }
    
    public func paymentQueue(_ queue: SKPaymentQueue, updatedDownloads downloads: [SKDownload]) {
        for download in downloads
        {
            switch (download.currentState) {
            case .active:
                if numberOfDownloads < 1 {
                    numberOfDownloads = 1;
                }
                let d : [String : Any] = ["DownloadName" : download.contentIdentifier,
                                          "DownloadProgress":download.progress/Float(numberOfDownloads)];
                NotificationCenter.default.post(name: CCStoreNotification.kIAPProductsDownloadInProgress, object: self, userInfo:d)
                break;
            case .finished:
                processDownload(download);
                break;
            case .failed, .cancelled:
                NotificationCenter.default.post(name: CCStoreNotification.kIAPProductsDownloadDidFinish, object: self)
                finishTransaction(download.transaction, successful:false);
                break;
            default:
                break;
            }
        }
    }
    
    public func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        productsIdentifiersToRestore.forEach {
            products[$0]?.onPurchaseComplete?()
        }
        NotificationCenter.default.post(name: CCStoreNotification.kIAPProductsDownloadDidFinish, object: self)
        productsIdentifiersToRestore.removeAll()
        numberOfDownloads = 0
        NotificationCenter.default.post(name: CCStoreNotification.kIAPProductsDownloadDidFinish, object: self)
    }
    
    public func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        NotificationCenter.default.post(name: CCStoreNotification.kIAPProductsDownloadDidFinish, object: self)
    }
}
