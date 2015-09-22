//
//  After.swift
//  After
//
//  Created by Remi Robert on 10/06/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

class Wait🕟Block {
    private var queue: dispatch_queue_t!
    private var executionBlocks: NSMutableDictionary!
    
    private class var sharedInstance: Wait🕟Block {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: Wait🕟Block? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = Wait🕟Block()
            Static.instance?.queue = dispatch_queue_create("com.remirobert.after", DISPATCH_QUEUE_SERIAL)
            Static.instance?.executionBlocks = NSMutableDictionary()
        }
        return Static.instance!
    }
    
    class func executeBlock(name: String, limitTimer timer: NSTimeInterval, completionBlock block:(() -> Void)) {

        var execute = true
        dispatch_sync(sharedInstance.queue, { () -> Void in
            var lastTimer = self.sharedInstance.executionBlocks[name] as? NSDate
            var lastInterval: NSTimeInterval!
            if lastTimer == nil {
                lastTimer = NSDate()
                lastInterval = 0
            }
            else {
                lastInterval = lastTimer!.timeIntervalSinceNow
            }
            if (lastInterval < 0 && fabs(lastInterval) < timer) {
                execute = false
            }
            else {
                self.sharedInstance.executionBlocks[name] = NSDate()
            }
        })
        if execute {
            block()
        }
    }
    
    class func resetAllTimer() {
        dispatch_sync(sharedInstance.queue, { () -> Void in
            self.sharedInstance.executionBlocks.removeAllObjects()
        })
    }

    class func resetTimer(name: String) {
        dispatch_sync(sharedInstance.queue, { () -> Void in
            self.sharedInstance.executionBlocks.removeObjectForKey(name)
        })
    }    
}
