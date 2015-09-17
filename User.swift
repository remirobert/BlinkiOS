//
//  User.swift
//  Blink
//
//  Created by Remi Robert on 17/09/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

import UIKit
import Parse
import ReactiveCocoa

class User: NSObject {

    class func findUser(phoneNumber: String) -> RACSignal {
        return RACSignal.createSignal({ (subscriber: RACSubscriber!) -> RACDisposable! in
            let querry = PFUser.query()
            querry?.whereKey("phoneNumber", equalTo: phoneNumber)
            
            querry?.getFirstObjectInBackgroundWithBlock({ (object: PFObject?, error: NSError?) -> Void in
                if let user = object where error == nil {
                    subscriber.sendNext(user)
                }
                else {
                    subscriber.sendError(error)
                }
                subscriber.sendCompleted()
            })
            return nil
        })
    }
    
}
