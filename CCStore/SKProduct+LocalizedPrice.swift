//
//  SKProduct+LocalizedPrice.swift
//  CCStore
//
//  Created by Chris on 12/10/18.
//  Copyright © 2018 Chris. All rights reserved.
//

import Foundation
import StoreKit

extension SKProduct {
    func localizedPrice() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = self.priceLocale
        return formatter.string(from: self.price)!
    }
}
