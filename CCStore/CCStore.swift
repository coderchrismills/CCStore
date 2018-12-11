//
//  CCStore.swift
//  CCStore
//
//  Created by Chris on 12/10/18.
//  Copyright © 2018 Chris. All rights reserved.
//

import Foundation
import StoreKit

public class CCStore: NSObject {
    internal var productsIdentifiersToRestore : [String] = []
    internal var numberOfDownloads = 0;
    internal var products : [String:CCStoreProductDescritor] = [:]
    internal var hasInitialized : Bool = false;
    internal var productsRequest : SKProductsRequest = SKProductsRequest()
    
    public override init() {
        super.init()
        initializeStore()
    }
    
    func initializeStore() {
        if(hasInitialized) {
            return;
        }
        
        SKPaymentQueue.default().add(self)
        hasInitialized = true
    }
    
    public func requestProducts(with identifiers: [String]) {
        let identifierSet = Set(identifiers)
        let request : SKProductsRequest = SKProductsRequest(productIdentifiers: identifierSet)
        request.delegate = self
        request.start()
    }
    
    public static func canMakePurchases() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    public func purchaseItem(_ item : CCStoreProductDescritor) {
        let payment = SKPayment(product: item.product)
        SKPaymentQueue.default().add(payment)
        numberOfDownloads = 1;
    }
    
    public func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    public func restorePurchase(with identifiers : [String]) {
        productsIdentifiersToRestore = identifiers
        numberOfDownloads = identifiers.count;
        restorePurchases()
    }
    
    public func getProductCount() -> Int {
        return products.count;
    }
    
}
