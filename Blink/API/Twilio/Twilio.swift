//
//  Twilio.swift
//  Blink
//
//  Created by Remi Robert on 17/09/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

import UIKit
import Parse
import ReactiveCocoa

class Twilio {

    private class func createTwilioSignal(phoneNumber: String, cloudFunction: String) -> RACSignal {
        return RACSignal.createSignal({ (subscriber: RACSubscriber!) -> RACDisposable! in
            
            let param = NSMutableDictionary()
            param.setValue(phoneNumber, forKey: "number")
            
            PFCloud.callFunctionInBackground(cloudFunction,
                withParameters: param as [NSObject : AnyObject],
                block: { (response: AnyObject?, error: NSError?) -> Void in
                    if let response = response as? NSDictionary where error == nil {
                        if let code = response["code"] as? Int {
                            subscriber.sendNext(code)
                            subscriber.sendCompleted()
                        }
                    }
                    else {
                        subscriber.sendError(error)
                    }
            })
            return nil
        })
    }
    
    class func basicAuth(phoneNumber: String) -> RACSignal {
        return createTwilioSignal(phoneNumber, cloudFunction: "sendCodeWithTwilio")
    }
    
    class func basicLogin(phoneNumber: String) -> RACSignal {
        return createTwilioSignal(phoneNumber, cloudFunction: "loginCodeWithTwilio")
    }
}
