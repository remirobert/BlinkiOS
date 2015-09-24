//
//  HoleView.swift
//  Sneak
//
//  Created by Remi Robert on 14/05/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

class HoleView: UIView {

    var tapEnable = true
    
    private lazy var imageView: UIImageView! = {
        let imageView = UIImageView()
        imageView.frame.origin = CGPointMake(0, 0)
        imageView.frame.size = UIScreen.mainScreen().bounds.size
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    var blockChangeSize: (()->())?
    
    var image: UIImage! {
        set {
            self.imageView.image = newValue
        }
        get {
            return self.imageView.image
        }
    }
    
    func updatePostion() {
        self.imageView.frame.origin = CGPointMake(-self.frame.origin.x, -self.frame.origin.y)
    }
        
    func changeSize(newSize: CGFloat) {
        let centerTmp = self.center
        
        UIView.animateWithDuration(2, animations: { () -> Void in
            self.frame.size = CGSizeMake(newSize, newSize)
            self.center = centerTmp

            self.updatePostion()
        })
        self.layer.cornerRadius = newSize / 2
        //self.makeCornerRadius()(newSize / 2).animate()(1.5)
    }
    
    func changeSize() {
        if self.tapEnable == false {
            return
        }
        var newSize: CGFloat = self.frame.size.width + 50.0
        if self.frame.size.width == 200 {
            newSize = 100.0
        }
        let centerTmp = self.center
        
        UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.3, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
            self.layer.cornerRadius = newSize / 2
            self.frame.size = CGSizeMake(newSize, newSize)
            self.center = centerTmp
            self.updatePostion()

            
            }) { (Bool) -> Void in
                
                if self.frame.origin.x < -self.frame.size.width / 2 {
                    self.frame.origin.x = -self.frame.size.width / 2
                }
                if self.frame.origin.x > UIScreen.mainScreen().bounds.size.width - self.frame.width / 2 {
                    self.frame.origin.x = UIScreen.mainScreen().bounds.size.width - self.frame.width / 2
                }
                
                if self.frame.origin.y < -self.frame.size.height / 2 {
                    self.frame.origin.y = -self.frame.size.height / 2
                }
                if self.frame.origin.y > UIScreen.mainScreen().bounds.size.height - self.frame.size.height / 2 {
                    self.frame.origin.y = UIScreen.mainScreen().bounds.size.height - self.frame.height / 2
                }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = frame.size.width / 2
        self.layer.masksToBounds = true
        
        self.addSubview(self.imageView)
        self.frame.origin = CGPointMake(UIScreen.mainScreen().bounds.size.width / 2 - frame.size.width / 2,
            UIScreen.mainScreen().bounds.size.height / 2 - frame.size.height / 2)
        self.imageView.frame.origin = CGPointMake(-self.frame.origin.x, -self.frame.origin.y)
        
        let gesture = UITapGestureRecognizer(target: self, action: "changeSize")
        self.addGestureRecognizer(gesture)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
