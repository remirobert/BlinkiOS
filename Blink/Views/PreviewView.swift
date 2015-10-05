//
//  PreviewView.swift
//  Sneak
//
//  Created by Remi Robert on 23/05/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit
import Parse

protocol PreviewViewDelegate {
    func displayPreview()
    func hideDisplay()
}

class PreviewView: UIView {

    lazy var progressView: UIActivityIndicatorView! = {
        let progress = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        progress.frame.size = CGSizeMake(100, 100)
        progress.frame.origin = CGPointMake(UIScreen.mainScreen().bounds.size.width / 2 - 50, UIScreen.mainScreen().bounds.size.height / 2 - 50)
        progress.hidesWhenStopped = true
        progress.color = UIColor.whiteColor()
        return progress
    }()
    
    lazy var previewContentImageView: UIImageView! = {
        let imageView = UIImageView()
        imageView.frame.origin = CGPointZero
        imageView.frame.size = CGSizeMake(CGRectGetWidth(UIScreen.mainScreen().bounds), CGRectGetHeight(UIScreen.mainScreen().bounds))
//        imageView.frame.size = CGSizeMake(UIScreen.mainScreen().bounds.size.width,
//            UIScreen.mainScreen().bounds.size.width + UIScreen.mainScreen().bounds.size.width / 4)
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.backgroundColor = UIColor.blackColor()
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    lazy var blurView: UIVisualEffectView! = {
        let darkBlur = UIBlurEffect(style: .Dark)
        let darkBlurView = UIVisualEffectView(effect: darkBlur)
        darkBlurView.layer.masksToBounds = true
        darkBlurView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
        return darkBlurView
    }()
    
    var textDrawerImageView: UIImageView!
    
    var delegate: PreviewViewDelegate?
    
    var blockDisplay: (() -> Void)?
    var blockHide: (() -> Void)?
    
    var holeView: HoleView!
    var holeSize: CGFloat!
    
    func startAnimation() {
        UIView.animateWithDuration(1, delay: 0.5, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
            let scaleTransform = CGAffineTransformMakeScale(20, 20)

            self.holeView.transform = scaleTransform
            
            }) { (Bool) -> Void in
        }
    }

    var timer: NSTimer!
    
    func animatedView() {
        if self.holeView.frame.size.height >= self.frame.size.height * 2 + 300 {
            self.holeView.layer.cornerRadius = self.holeView.frame.size.width / 2
            self.timer.invalidate()
            return
        }
        let tmpCenter = self.holeView.center
        UIView.animateWithDuration(0.01, animations: { () -> Void in
            self.holeView.frame.size = CGSizeMake(self.holeView.frame.size.width + 15, self.holeView.frame.size.height + 15)
            self.holeView.layer.cornerRadius = (self.holeView.frame.size.width + 15) / 2
            self.holeView.center = tmpCenter
            self.holeView.updatePostion()
        })
    }
    
    func unAnimatedView() {
        if self.holeView.frame.size.width <= self.holeSize {
            self.holeView.layer.cornerRadius = self.holeView.frame.size.width / 2
            self.timer.invalidate()
            self.rezStateHoleView()
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.textDrawerImageView.alpha = 1
            })
            return
        }
        let tmpCenter = self.holeView.center
        UIView.animateWithDuration(0.01, animations: { () -> Void in
            self.holeView.frame.size = CGSizeMake(self.holeView.frame.size.width - 15, self.holeView.frame.size.height - 15)
            self.holeView.layer.cornerRadius = (self.holeView.frame.size.width - 15) / 2
            self.holeView.center = tmpCenter
            self.holeView.updatePostion()
        })
    }
    
    func rezStateHoleView() {
        let tmpCenter = self.holeView.center
        self.holeView.frame.size = CGSizeMake(self.holeSize, self.holeSize)
        self.holeView.layer.cornerRadius = self.holeSize / 2
        self.holeView.center = tmpCenter
        self.holeView.updatePostion()
    }
    
    /*
    CGFloat animationDuration = 4.0; // Your duration
    CGFloat animationDelay = 3.0; // Your delay (if any)
    
    CABasicAnimation *cornerRadiusAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    [cornerRadiusAnimation setFromValue:[NSNumber numberWithFloat:50.0]]; // The current value
    [cornerRadiusAnimation setToValue:[NSNumber numberWithFloat:10.0]]; // The new value
    [cornerRadiusAnimation setDuration:animationDuration];
    [cornerRadiusAnimation setBeginTime:CACurrentMediaTime() + animationDelay];
    
    // If your UIView animation uses a timing funcition then your basic animation needs the same one
    [cornerRadiusAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    // This will keep make the animation look as the "from" and "to" values before and after the animation
    [cornerRadiusAnimation setFillMode:kCAFillModeBoth];
    [[circle layer] addAnimation:cornerRadiusAnimation forKey:@"keepAsCircle"];
    [[circle layer] setCornerRadius:10.0]; // Core Animation doesn't change the real value so we have to.
    
    [UIView animateWithDuration:animationDuration
    delay:animationDelay
    options:UIViewAnimationOptionCurveEaseInOut
    animations:^{
    [[circle layer] setFrame:CGRectMake(50, 50, 20, 20)]; // Arbitrary frame ...
    // You other UIView animations in here...
    } completion:^(BOOL finished) {
    // Maybe you have your completion in here...
    }];
*/
    
    func animationHole() {
        let newSize = (self.frame.size.height * 2 + 300)
        let center = self.holeView.center
        let animationDuration = 1.5
        
        let cornerRadiusAnimation = CABasicAnimation(keyPath: "cornerRadius")
        cornerRadiusAnimation.fromValue = self.holeView.layer.cornerRadius
        cornerRadiusAnimation.toValue = newSize / 2
        cornerRadiusAnimation.duration = animationDuration
        cornerRadiusAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        cornerRadiusAnimation.fillMode = kCAFillModeBoth
        holeView.layer.addAnimation(cornerRadiusAnimation, forKey: "animation")
        holeView.layer.cornerRadius = newSize / 2
        
        
        UIView.animateWithDuration(animationDuration, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            
            self.holeView.frame.size = CGSizeMake(newSize, newSize)
            self.holeView.center = center
            self.holeView.updatePostion()
            
            }) { (_) -> Void in
                
        }
    }
    
    func animationBackHole() {
        let newSize = self.holeSize
        let center = self.holeView.center
        let animationDuration = 1.5
        
        self.holeView.layer.removeAllAnimations()
        self.holeView.updatePostion()
        
        let cornerRadiusAnimation = CABasicAnimation(keyPath: "cornerRadius")
        cornerRadiusAnimation.fromValue = self.holeView.layer.cornerRadius
        cornerRadiusAnimation.toValue = newSize / 2
        cornerRadiusAnimation.duration = animationDuration
        cornerRadiusAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        cornerRadiusAnimation.fillMode = kCAFillModeBoth
        holeView.layer.addAnimation(cornerRadiusAnimation, forKey: "animation")
//        holeView.layer.cornerRadius = newSize / 2
        
        
        UIView.animateWithDuration(animationDuration, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            
            self.holeView.frame.size = CGSizeMake(newSize, newSize)
            self.holeView.center = center
            self.holeView.updatePostion()
            
            }) { (_) -> Void in
                
        }
    }
    
    func longPressGestureRecognizer(gesture: UILongPressGestureRecognizer) {
        
        
        
        switch gesture.state {
        case UIGestureRecognizerState.Began:
            if let block = blockDisplay {
                block()
            }
            delegate?.displayPreview()
            self.rezStateHoleView()
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.textDrawerImageView.alpha = 0
            })
            if let _ = self.timer {
                self.timer.invalidate()
            }
            self.holeView.frame.size = CGSizeMake(self.holeSize, self.holeSize)
            self.holeView.layer.cornerRadius = self.holeSize / 2
            self.timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "animatedView", userInfo: nil, repeats: true)

        case UIGestureRecognizerState.Cancelled, UIGestureRecognizerState.Ended, UIGestureRecognizerState.Failed:
            if let block = blockHide {
                block()
            }
            delegate?.hideDisplay()
            self.timer.invalidate()
            self.timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "unAnimatedView", userInfo: nil, repeats: true)
            
        default:Void()
        }
    }
    
    func loadContentWithObject(image: UIImage, imageTextDrawer: UIImage, positionHole: CGPoint, sizeHole: CGFloat) {
        self.layer.masksToBounds = true
        
        let positionHole = CGPointMake(UIScreen.mainScreen().bounds.size.width / positionHole.x, UIScreen.mainScreen().bounds.size.height / positionHole.y)
        let sizeHole = CGSizeMake(UIScreen.mainScreen().bounds.size.width / sizeHole, UIScreen.mainScreen().bounds.size.width / sizeHole)
        
        self.holeView.frame = CGRectMake(positionHole.x, positionHole.y, sizeHole.width, sizeHole.height)
        self.holeView.frame.origin = positionHole
        self.holeView.image = image
        self.holeView.updatePostion()
        self.previewContentImageView.image = image
        self.blurView.frame = self.previewContentImageView.frame
        
        self.holeView.layer.cornerRadius = self.holeView.frame.size.width / 2
        self.holeSize = self.holeView.frame.size.width
        
        self.textDrawerImageView.image = imageTextDrawer
        
        let longpressGesture = UILongPressGestureRecognizer(target: self, action: "longPressGestureRecognizer:")
        longpressGesture.minimumPressDuration = 0.1
        self.addGestureRecognizer(longpressGesture)
        self.progressView.stopAnimating()
    }
    
    func loadContent(content: PFObject, photo: UIImage, text: UIImage?) {
        self.progressView.startAnimating()
        
        self.previewContentImageView.image = nil
        self.holeView.image = nil
        
        self.layer.masksToBounds = true
        
        let positionHole = CGPointMake(UIScreen.mainScreen().bounds.size.width / CGFloat((content["positionHoleX"] as! NSNumber).floatValue), UIScreen.mainScreen().bounds.size.height / CGFloat((content["positionHoleY"] as! NSNumber).floatValue))
        let sizeHole = CGSizeMake(UIScreen.mainScreen().bounds.size.width / CGFloat((content["sizeHole"] as! NSNumber).floatValue), UIScreen.mainScreen().bounds.size.width / CGFloat((content["sizeHole"] as! NSNumber).floatValue))
        
        self.holeView.frame = CGRectMake(positionHole.x, positionHole.y, sizeHole.width, sizeHole.height)
        self.holeView.frame.origin = positionHole
        self.holeView.image = photo
        self.holeView.updatePostion()
        self.previewContentImageView.image = photo
        self.blurView.frame = self.previewContentImageView.frame
        
        self.holeView.layer.cornerRadius = self.holeView.frame.size.width / 2
        self.holeSize = self.holeView.frame.size.width
        
        if let _ = text {
            self.textDrawerImageView.image = text
        }
        
        let longpressGesture = UILongPressGestureRecognizer(target: self, action: "longPressGestureRecognizer:")
        longpressGesture.minimumPressDuration = 0.1
        self.addGestureRecognizer(longpressGesture)
        self.progressView.stopAnimating()
    }

    func setupView() {
        self.backgroundColor = UIColor.blackColor()
        self.addSubview(self.previewContentImageView)
        
        self.holeView = HoleView()
        self.holeView.frame.origin = CGPointZero
        self.holeView.tapEnable = false
        self.holeView.updatePostion()
        self.previewContentImageView.frame.size = self.frame.size
        self.previewContentImageView.center = self.center
        self.blurView.frame = self.previewContentImageView.frame
        
        self.addSubview(self.blurView)
        self.addSubview(self.holeView)
        
        textDrawerImageView = UIImageView(frame: self.frame)
        textDrawerImageView.backgroundColor = UIColor.clearColor()
        textDrawerImageView.contentMode = UIViewContentMode.ScaleAspectFit
        self.addSubview(textDrawerImageView)
        
        self.holeSize = self.holeView.frame.size.width
        
        self.progressView.startAnimating()
        self.addSubview(self.progressView)
    }
    
    init() {
        super.init(frame: CGRectMake(0, 0,
            UIScreen.mainScreen().bounds.size.width,
            UIScreen.mainScreen().bounds.size.height))
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
}
