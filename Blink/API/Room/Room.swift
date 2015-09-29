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
    
    class func fetchBlinkRoom(room: PFObject) -> RACSignal {
        return RACSignal.createSignal({ (subscriber: RACSubscriber!) -> RACDisposable! in
            
            let relationMedia = room.relationForKey("contents")
            let querryMedia = relationMedia.query()
            querryMedia?.orderByDescending("createdAt")
            
            querryMedia?.findObjectsInBackgroundWithBlock({ (results: [PFObject]?, error: NSError?) -> Void in
                if error != nil {
                    subscriber.sendError(error)
                    return
                }
                if let blinks = results {
                    subscriber.sendNext(blinks)
                    subscriber.sendCompleted()
                }
            })
            return nil
        })
    }
    
    class func fetchPublicRoom() -> RACSignal {
        return RACSignal.createSignal({ (subscriber: RACSubscriber!) -> RACDisposable! in
            let querry = PFQuery(className: "privateRoom")
            querry.whereKey("public", equalTo: true)
            querry.cachePolicy = PFCachePolicy.CacheThenNetwork
            
            return nil
        })
    }
    
    class func fetchRooms() -> RACSignal {
        return RACSignal.createSignal({ (subscriber: RACSubscriber!) -> RACDisposable! in
            let querry = PFQuery(className: "privateRoom")
            querry.whereKey("participants", equalTo: PFUser.currentUser()!)
            querry.orderByDescending("updatedAt")
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
    
    class func addNewBlinkToRoom(photo: UIImage, textImage: UIImage?, blinkData: BlinkData, room: PFObject) -> RACSignal {
        return RACSignal.createSignal({ (subscriber: RACSubscriber!) -> RACDisposable! in
            
            Blink.createBlink(photo, textImage: textImage, blinkData: blinkData).subscribeNext({ (next: AnyObject!) -> Void in
                
                if let blink = next as? PFObject {
                    addBlinkRoom(room, blink: blink)
                    
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
                
                }, error: { (error: NSError!) -> Void in
                    subscriber.sendError(error)
            })
            return nil
        })
    }
    
    class func createNewRoom(title: String, blink: PFObject, participants: [PFObject]) -> RACSignal {
        return RACSignal.createSignal({ (subscriber: RACSubscriber!) -> RACDisposable! in
            let newRoom = PFObject(className: "privateRoom")
            newRoom.setValue(PFUser.currentUser(), forKey: "creator")
            newRoom.setValue(PFUser.currentUser()!["trueUsername"] as? String, forKey: "username")
            newRoom.setValue(title, forKey: "title")
            newRoom.setValue(false, forKey: "public")
            newRoom.setValue(false, forKey: "global")
            newRoom.setValue(1, forKey: "numberMedias")
            
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
