//
//  AppDelegate.swift
//  Blink
//
//  Created by Remi Robert on 17/09/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

import UIKit
import Parse

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
        let startUpController = UIStoryboard.instanceController("startupController")
        window?.rootViewController = startUpController
        
        Parse.setApplicationId("DU6edKCcIY9jOtr6ETShTM3FQr9vyYpzXDKJ6SAf", clientKey: "YPptEdeHL3EgJcNEPBI6m6HsVlGYpGBGmQIKX2Oh")
        applicationAppaerence()
        return true
    }
}

