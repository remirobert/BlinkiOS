//
//  Alert.swift
//  Blink
//
//  Created by Remi Robert on 17/09/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

import UIKit

class Alert {
    
    class var sharedInstance: UIAlertController {
        struct Static {
            static var alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        }
        return Static.alert
    }
    
    class func displayError(message: String) -> UIAlertController {
        let alert = self.sharedInstance
        alert.title = "Error"
        alert.message = message
        
        let cancelAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel) { (_) -> Void in }
        alert.addAction(cancelAction)
        return alert
    }
    
}
