//
//  Blink.swift
//  Blink
//
//  Created by Remi Robert on 25/09/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

import UIKit
import Parse
import ReactiveCocoa

struct BlinkData {
    var positionX: Float
    var positionY: Float
    var sizeHole: Float
    var message: String
    
    init(positionX: Float, positionY: Float, sizeHole: Float, message: String) {
        self.positionX = positionX
        self.positionY = positionY
        self.sizeHole = sizeHole
        self.message = message
    }
}

class Blink {

    class func saveFileBlink(photo: UIImage, textImage: UIImage?) -> RACSignal {
        return RACSignal.createSignal({ (subsciber: RACSubscriber!) -> RACDisposable! in
            
            var signalSaveText: RACSignal?
            let signalSavePhoto = File.saveFile(UIImageJPEGRepresentation(photo, 0.5)!)
            
            if let textImage = textImage {
                signalSaveText = File.saveFile(UIImagePNGRepresentation(textImage)!)
            }
            signalSavePhoto.subscribeNext({ (next: AnyObject!) -> Void in
                if let filePhoto = next as? PFFile {
                    if let signalSaveText = signalSaveText {
                        signalSaveText.subscribeNext({ (next: AnyObject!) -> Void in
                            if let fileText = next as? PFFile {
                                subsciber.sendNext(RACTuple(objectsFromArray: [filePhoto, fileText]))
                                subsciber.sendCompleted()
                            }
                            else {
                                subsciber.sendError(nil)
                                return
                            }
                            
                            }, error: { (error: NSError!) -> Void in
                                subsciber.sendError(error)
                                return
                        })
                    }
                    else {
                        subsciber.sendNext(RACTuple(objectsFromArray: [filePhoto]))
                        subsciber.sendCompleted()
                    }
                }
                }, error: { (error: NSError!) -> Void in
                    subsciber.sendError(error)
            })
            return nil
        })
    }

    class func createBlink(photo: UIImage, textImage: UIImage?, blinkData: BlinkData) -> RACSignal {
        return RACSignal.createSignal({ (subsciber: RACSubscriber!) -> RACDisposable! in
            
            saveFileBlink(photo, textImage: textImage).subscribeNext({ (next: AnyObject!) -> Void in
                
                if let tuple = next as? RACTuple, let photoFile = tuple.first as? PFFile {
                    
                    let newBlink = PFObject(className: "Sneak")
                    newBlink.setValue(photoFile, forKey: "image")
                    newBlink.setValue(blinkData.positionX, forKey: "positionHoleX")
                    newBlink.setValue(blinkData.positionY, forKey: "positionHoleY")
                    newBlink.setValue(blinkData.sizeHole, forKey: "sizeHole")
                    newBlink.setValue(blinkData.message, forKey: "message")
                    newBlink.setValue(PFUser.currentUser()!, forKey: "creator")
                    
                    if let textFile = tuple.second as? PFFile {
                        newBlink.setValue(textFile, forKey: "textDrawer")
                    }
                    
                    newBlink.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                        if success && error == nil {
                            subsciber.sendNext(newBlink)
                            subsciber.sendCompleted()
                        }
                        else {
                            subsciber.sendError(nil)
                        }
                    })
                }
                else {
                    subsciber.sendError(nil)
                }
                
                }, error: { (error: NSError!) -> Void in
                    subsciber.sendError(error)
            })
            return nil
        })
    }
}
