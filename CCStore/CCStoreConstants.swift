//
//  CCStoreConstants.swift
//  CCStore
//
//  Created by Chris on 12/10/18.
//  Copyright © 2018 Chris. All rights reserved.
//

import Foundation

public struct CCStoreNotification {
    public static let kIAPTransactionFailed = NSNotification.Name(rawValue: "kIAPTransactionFailedNotification")
    public static let kIAPTransactionSucceeded = NSNotification.Name(rawValue: "kIAPTransactionSucceededNotification")
    public static let kIAPProductsFetched = NSNotification.Name(rawValue: "kIAPProductsFetchedNotification")
    public static let kIAPProductsDownloadInProgress = NSNotification.Name(rawValue: "kIAPProductsDownloadInProgress")
    public static let kIAPProductsDownloadDidFinish = NSNotification.Name(rawValue: "kIAPProductsDownloadDidFinish")
    public static let kIAPProductsRestoreDidFinish = NSNotification.Name(rawValue: "kIAPProductsRestoreDidFinish")
}
