//
//  CCStore+SKProductRequestDelegate.swift
//  CCStore
//
//  Created by Chris on 12/10/18.
//  Copyright © 2018 Chris. All rights reserved.
//

import Foundation
import StoreKit

extension CCStore: SKProductsRequestDelegate {
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        let user_info = ["error" : error]
        NotificationCenter.default.post(name: CCStoreNotification.kIAPTransactionFailed, object: user_info)
    }
    
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let responseProducts = response.products.sorted { $0.price.floatValue < $1.price.floatValue }
        for product in responseProducts {
            products[product.productIdentifier]?.product = product
        }
        
        NotificationCenter.default.post(name: CCStoreNotification.kIAPProductsFetched, object: nil)
    }
}
