//
//  PushNotification.swift
//  Blink
//
//  Created by Remi Robert on 05/10/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

import UIKit
import Parse

class PushNotification {

    class func addUserChannel() {
        let currentInstallation = PFInstallation.currentInstallation()

        if let channels = currentInstallation.channels as? [String], let currentUser = PFUser.currentUser() {
            if channels.contains("c\(currentUser.objectId)") == false {
                currentInstallation.addUniqueObject("c\(currentUser.objectId)", forKey: "channels")
                currentInstallation.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                    if error != nil {
                        print("[NOTIFICATION CHANNELS] : Error save current installation: \(error)")
                    }
                    print("[NOTIFICATION CHANNELS] : success save current installation: \(success)")
                })
            }
        }
    }
    
    class func new(room: PFObject) {
        let participantsRelation = room.relationForKey("participants")
        participantsRelation.query()?.findObjectsInBackgroundWithBlock({ (results:[PFObject]?, error: NSError?) -> Void in
            if error != nil {
                print("[PFPUSH] Error find participants : \(error)")
                return
            }
            if let users = results {
                var userIds = Array<String>()
                for currentUser in users {
                    userIds.append("c\(currentUser.objectId!)")
                }
                sendNotification(userIds, message: "New blink !")
            }
        })
    }
    
    class func sendNotification(channels: [String], message: String) {
        let pushNotification = PFPush()
        let dataNotification = ["alert": message, "sound": "default"]
        
        pushNotification.setChannels(channels)
        pushNotification.setData(dataNotification)
        
        pushNotification.sendPushInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if error != nil {
                print("[PFPUSH] Error send notification push : \(error)")
                return
            }
            print("[PFPUSH] Success send notification push : \(success)")
        }
    }
}
