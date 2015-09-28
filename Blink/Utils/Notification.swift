//
//  Notification.swift
//  Blink
//
//  Created by Remi Robert on 28/09/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

import UIKit

enum Notification: String {
    case RefreshFeed = "refreshFeed"
}

extension NSNotificationCenter {
    
    class func refreshFeed() {
        NSNotificationCenter.defaultCenter().postNotificationName(Notification.RefreshFeed.rawValue, object: nil)
    }
    
}