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

class User {

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
    
    class func signupUser(phoneNumber: String, username: String) -> RACSignal {
        return RACSignal.createSignal({ (subscriber: RACSubscriber!) -> RACDisposable! in
            
            let newUser = PFUser()
            newUser.setValue(phoneNumber, forKey: "phoneNumber")
            newUser.setValue(phoneNumber, forKey: "username")
            newUser.setValue(username, forKey: "trueUsername")
            newUser.setValue(phoneNumber, forKey: "password")
            
            newUser.signUpInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                if success && error == nil {
                    subscriber.sendNext(true)
                }
                else {
                    subscriber.sendError(error)
                }
                subscriber.sendCompleted()
            })
            return nil
        })
    }
    
    class func loginUser(phoneNumber: String) -> RACSignal {
        return RACSignal.createSignal({ (subscriber: RACSubscriber!) -> RACDisposable! in
            PFUser.logInWithUsernameInBackground(phoneNumber, password: phoneNumber, block: { (user: PFUser?, error: NSError?) -> Void in
                if let user = user where error == nil {
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