//
//  Friend.swift
//  Blink
//
//  Created by Remi Robert on 22/09/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

import UIKit
import Parse
import ReactiveCocoa

class Friend {

    class func searchFriends(searchString: String) -> RACSignal {
        return RACSignal.createSignal({ (subscriber: RACSubscriber!) -> RACDisposable! in
            
            let querry = PFUser.query()
            querry?.cachePolicy = PFCachePolicy.CacheThenNetwork
            querry?.whereKeyExists("trueUsername")
            querry?.whereKey("trueUsername", containsString: searchString)
            querry?.findObjectsInBackgroundWithBlock({ (results: [PFObject]?, error: NSError?) -> Void in
                
                if error != nil {
                    subscriber.sendError(error)
                    return
                }
                if let users = results where error == nil {
                    PFObject.fetchAllIfNeededInBackground(users, block: { (fetchedResults: [AnyObject]?, error: NSError?) -> Void in
                        if error != nil {
                            subscriber.sendError(error)
                            return
                        }
                        if let fetchedUsers = fetchedResults {
                            subscriber.sendNext(fetchedUsers)
                        }
                        subscriber.sendCompleted()
                    })
                }
                else {
                    subscriber.sendCompleted()
                }
            })
            return nil
        })
    }
    
    class func friends() -> RACSignal {
        return RACSignal.createSignal({ (subscriber: RACSubscriber!) -> RACDisposable! in
            
            let currentUser = PFUser.currentUser()
            let querryFriendsRelation = currentUser?.relationForKey("friends").query()
            querryFriendsRelation?.cachePolicy = PFCachePolicy.CacheThenNetwork

            querryFriendsRelation?.findObjectsInBackgroundWithBlock({ (results: [PFObject]?, error: NSError?) -> Void in
                if let friends = results where error == nil {
                    subscriber.sendNext(friends)
                }
                else {
                    subscriber.sendError(error)
                    return
                }
                subscriber.sendCompleted()
            })
            return nil
        })
    }
    
}
