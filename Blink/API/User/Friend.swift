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
    
    class func removeFriend(friend: PFObject) -> RACSignalsign
    
    
    class func addFriend(friend: PFObject) -> RACSignal {
        return RACSignal.createSignal({ (subscriber: RACSubscriber!) -> RACDisposable! in
            
            let friendsRelation = PFUser.currentUser()?.relationForKey("friends")
            friendsRelation?.addObject(friend)
            
            PFUser.currentUser()?.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
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
    
    class func isFriend(friend: PFObject, friends: [PFObject]) -> Bool {
        if friends.contains(friend) {
            return true
        }
        else {
            return false
        }
    }

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
    
    class func friends(cachePolicy: PFCachePolicy = PFCachePolicy.CacheThenNetwork) -> RACSignal {
        return RACSignal.createSignal({ (subscriber: RACSubscriber!) -> RACDisposable! in
            
            let currentUser = PFUser.currentUser()
            let querryFriendsRelation = currentUser?.relationForKey("friends").query()
            querryFriendsRelation?.cachePolicy = PFCachePolicy.CacheThenNetwork

            querryFriendsRelation?.findObjectsInBackgroundWithBlock({ (results: [PFObject]?, error: NSError?) -> Void in
                if let friends = results where error == nil {
                    PFObject.fetchAllIfNeededInBackground(friends, block: { (fetchedResults: [AnyObject]?, error: NSError?) -> Void in
                        if error != nil {
                            subscriber.sendError(error)
                        }
                        else {
                            if let fetchedFriends = fetchedResults as? [PFObject] {
                                subscriber.sendNext(fetchedFriends)
                                subscriber.sendCompleted()
                            }
                            else {
                                subscriber.sendError(error)
                            }
                        }
                    })
                }
                else {
                    subscriber.sendError(error)
                    return
                }
            })
            return nil
        })
    }
    
}
