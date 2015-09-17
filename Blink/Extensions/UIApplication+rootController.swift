//
//  UIApplication+rootController.swift
//  Blink
//
//  Created by Remi Robert on 17/09/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

import UIKit

extension UIApplication {

    class func changeRootController(controllerIdentifier: String) {
        if let application =  self.sharedApplication().delegate as? AppDelegate {
            application.window?.rootViewController = UIStoryboard.instanceController(controllerIdentifier)
        }
    }
}
