//
//  Progress.swift
//  Blink
//
//  Created by Remi Robert on 17/09/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

import UIKit
import MBProgressHUD

class Progress {

    class func show(view: UIView, message: String, color: UIColor = UIColor.whiteColor()) -> MBProgressHUD {
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.labelText = message
        hud.opaque = true
        hud.opacity = 0.5
        hud.labelFont = UIFont(name: "ArialRoundedMTBold", size: 15)!
        hud.mode = MBProgressHUDMode.CustomView
        
        let imageLogo = UIImageView(frame: CGRectMake(0, 0, 37, 37))
        
        if color != UIColor.whiteColor() {
            let colorsComponent = Colors.colorAndFaceFromColor(color)
            hud.labelColor = colorsComponent.secondColor
            imageLogo.image = colorsComponent.face
            hud.color = color
        }
        else {
            imageLogo.image = UIImage(named: "defaultFace")
            hud.color = UIColor(red:0.99, green:0.36, blue:0.39, alpha:1)
        }
        
        
        hud.customView = imageLogo
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber(float: Float(M_PI) * 2.0)
        rotationAnimation.duration = 1.5
        rotationAnimation.cumulative = true
        rotationAnimation.repeatCount = 150
        
        imageLogo.layer.addAnimation(rotationAnimation, forKey: "anim")
        
        return hud
    }
    
}
