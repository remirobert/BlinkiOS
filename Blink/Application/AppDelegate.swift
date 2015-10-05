//
//  AppDelegate.swift
//  Blink
//
//  Created by Remi Robert on 17/09/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

import UIKit
import Parse
import PBJVision
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    lazy var window: UIWindow? = {
        let window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window.makeKeyAndVisible()
        return window
    }()

    func applicationAppaerence() {
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.shadowImage = UIImage()
        navigationBarAppearance.backgroundColor = UIColor.whiteColor()
        navigationBarAppearance.titleTextAttributes = [NSFontAttributeName: UIFont(name: "ArialRoundedMTBold", size: 15)!,
            NSForegroundColorAttributeName: UIColor(red:0.99, green:0.37, blue:0.4, alpha:1)]
        navigationBarAppearance.tintColor = UIColor(red:0.99, green:0.36, blue:0.39, alpha:1)
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        Fabric.with([Crashlytics.self()])
        Parse.setApplicationId("DU6edKCcIY9jOtr6ETShTM3FQr9vyYpzXDKJ6SAf", clientKey: "YPptEdeHL3EgJcNEPBI6m6HsVlGYpGBGmQIKX2Oh")
        
        let pushSettings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        application.registerUserNotificationSettings(pushSettings)
        application.registerForRemoteNotifications()
        
        var controller: UIViewController!
        
        if PFUser.currentUser() == nil {
            controller = UIStoryboard.instanceController("startupController")
        }
        else {
            controller = UIStoryboard.instanceController("mainController")
        }

        window?.rootViewController = controller
        PBJVision.sharedInstance().startPreview()
        applicationAppaerence()
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.channels = ["gloabal"]
        installation.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if error != nil {
                print("[NOTIFICATION]: Error register notification token")
            }
            if success {
                print("[NOTIFICATION]: Success register notification token")
            }
            else {
                print("[NOTIFICATION]: failed register notification token")
            }
        }
    }
}

