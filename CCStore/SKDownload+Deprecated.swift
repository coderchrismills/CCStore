//
//  SKDownload+Deprecated.swift
//  CCStore
//
//  Created by Chris on 12/10/18.
//  Copyright © 2018 Chris. All rights reserved.
//

import Foundation
import StoreKit

extension SKDownload {
    var currentState: SKDownloadState {
        if #available(iOS 12.0, *) {
           return self.state
        } else {
            return self.downloadState
        }
    }
}
