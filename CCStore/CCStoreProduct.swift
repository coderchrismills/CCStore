//
//  CCStoreProduct.swift
//  CCStore
//
//  Created by Chris on 12/10/18.
//  Copyright © 2018 Chris. All rights reserved.
//

import Foundation
import StoreKit

public protocol CCStoreProductDescritor {
    var identifier: String { get }
    var product: SKProduct { get set }
    var title: String { get }
    var price: String { get }
    var localizedDescription: String { get }
    var onPurchaseComplete:(()->())? { get set }
    
    func record(receipt: Data?)
}

public struct CCStoreProduct: CCStoreProductDescritor {
    fileprivate var _identifier: String = ""
    public var identifier: String { return _identifier }
    
    public var product: SKProduct
    
    public var title: String {
        return product.localizedTitle
    }
    
    public var price: String {
        return product.localizedPrice()
    }
    
    public var localizedDescription: String {
        return product.localizedDescription
    }
    
    var receiptIdentifier: String {
        return "\(_identifier)_receipt"
    }
    
    public var onPurchaseComplete: (() -> ())?
    
    public init(identifier: String, product: SKProduct) {
        self._identifier = identifier
        self.product = product
    }
    
    public func hasPurchased() -> Bool {
        return UserDefaults.standard.bool(forKey: _identifier)
    }
    
    func purchase() {
        UserDefaults.standard.set(true, forKey: _identifier)
        UserDefaults.standard.synchronize()
        onPurchaseComplete?()
    }
    
    public func record(receipt: Data?) {
        UserDefaults.standard.set(receipt, forKey: receiptIdentifier)
        UserDefaults.standard.synchronize()
    }
}
