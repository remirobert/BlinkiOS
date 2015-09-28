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

/*
PFQuery *query = [PFQuery queryWithClassName:@"Teacher"];
[query whereKey:@"students" equalTo:student];
In this example, the student is a PFObject with a className that matches the relation in "students". If this is a relation of PFUsers and you're looking for the current user's "Teacher"s, you'd use:

PFQuery *query = [PFQuery queryWithClassName:@"Teacher"];
[query whereKey:@"students" equalTo:[PFUser currentUser]];
*/


class Room {
    
    class func addParticipantRoom(room: PFObject, participants: [PFObject]) {
        let relationParticipants = room.relationForKey("participants")
        for currentParticipant in participants {
            relationParticipants.addObject(currentParticipant)
        }
    }
    
    class func addBlinkRoom(room: PFObject, blink: PFObject) {        
        let relationContents = room.relationForKey("contents")
        relationContents.addObject(blink)
    }
    
    class func createNewRoom(title: String, blink: PFObject, participants: [PFObject]) -> RACSignal {
        return RACSignal.createSignal({ (subscriber: RACSubscriber!) -> RACDisposable! in
            let newRoom = PFObject(className: "privateRoom")
            newRoom.setValue(PFUser.currentUser(), forKey: "creator")
            newRoom.setValue(title, forKey: "title")
            
            addParticipantRoom(newRoom, participants: participants)
            addBlinkRoom(newRoom, blink: blink)
            
            newRoom.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                if success && error == nil {
                    subscriber.sendNext(newRoom)
                }
                else {
                    subscriber.sendError(error)
                }
                subscriber.sendCompleted()
            })
            return nil
        })
    }
    
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
