//
//  Room.swift
//  Blink
//
//  Created by Remi Robert on 18/09/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

import UIKit
import Parse
import ReactiveCocoa

class Room {

    class func fetchDirectRoomParticipantUser() -> RACSignal {
        return RACSignal.createSignal({ (subscriber: RACSubscriber!) -> RACDisposable! in
            
            let querryParticipant = PFQuery(className: "Participant")
            
            querryParticipant.whereKey("user", equalTo: PFUser.currentUser()!)
            querryParticipant.findObjectsInBackgroundWithBlock({ (results: [PFObject]?, error: NSError?) -> Void in
                if let participants = results where error == nil {
                    let rooms = participants.flatMap { ($0["room"]) }
                    
                    PFObject.fetchAllIfNeededInBackground(rooms, block: { (fetchedResults: [AnyObject]?, error: NSError?) -> Void in

                        if let fetchedRooms = fetchedResults where error == nil {
                            subscriber.sendNext(fetchedRooms)
                            subscriber.sendCompleted()
                        }
                        else {
                            subscriber.sendError(error)
                        }
                    })
                }
                else {
                    subscriber.sendError(error)
                }
            })
            return nil
        })
    }
}
