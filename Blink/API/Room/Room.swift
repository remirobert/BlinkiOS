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
    
    class func fetchRooms() -> RACSignal {
        return RACSignal.createSignal({ (subscriber: RACSubscriber!) -> RACDisposable! in
            let querry = PFQuery(className: "privateRoom")
            querry.whereKey("participants", equalTo: PFUser.currentUser()!)
            querry.cachePolicy = PFCachePolicy.CacheThenNetwork
            
            querry.findObjectsInBackgroundWithBlock({ (results: [PFObject]?, error: NSError?) -> Void in
                if error != nil {
                    subscriber.sendError(error)
                }
                print("results : \(results)")
                if let rooms = results {
                    subscriber.sendNext(rooms)
                    subscriber.sendCompleted()
                }
                subscriber.sendNext(nil)
                subscriber.sendCompleted()
            })
            return nil
        })
    }
    
    private class func addParticipantRoom(room: PFObject, participants: [PFObject]) {
        let relationParticipants = room.relationForKey("participants")
        for currentParticipant in participants {
            relationParticipants.addObject(currentParticipant)
        }
    }
    
    private class func addBlinkRoom(room: PFObject, blink: PFObject) {
        let relationContents = room.relationForKey("contents")
        relationContents.addObject(blink)
    }
    
    class func createNewRoom(title: String, blink: PFObject, participants: [PFObject]) -> RACSignal {
        return RACSignal.createSignal({ (subscriber: RACSubscriber!) -> RACDisposable! in
            let newRoom = PFObject(className: "privateRoom")
            newRoom.setValue(PFUser.currentUser(), forKey: "creator")
            newRoom.setValue(title, forKey: "title")
            newRoom.setValue(false, forKey: "public")
            newRoom.setValue(false, forKey: "global")
            
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
    
    class func makeRoomPublic(room: PFObject, distance: String) -> RACSignal {
        return RACSignal.createSignal({ (subscriber: RACSubscriber!) -> RACDisposable! in

            PFGeoPoint.geoPointForCurrentLocationInBackground({ (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
                
                if error != nil {
                    subscriber.sendError(error)
                }
                if let geoPoint = geoPoint {
                    room.setValue(geoPoint, forKey: "position")
                    room.setValue(true, forKey: "public")
                    if distance == "Nearby (<25km)" {
                        room.setValue(false, forKey: "global")
                    }
                    else {
                        room.setValue(true, forKey: "global")
                    }
                    
                    room.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                        if success && error == nil {
                            subscriber.sendNext(room)
                            subscriber.sendCompleted()
                        }
                        else {
                            subscriber.sendError(error)
                        }
                    })
                }
                else {
                    subscriber.sendError(nil)
                }
            })
            return nil
        })
    }
}
