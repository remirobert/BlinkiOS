//
//  CameraPreviewViewController.swift
//  Blink
//
//  Created by Remi Robert on 24/09/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

import UIKit
import PBJVision
import jot
import Masonry

enum Drag {
    case Circle, None
}

class CameraPreviewViewController: UIViewController {

    var photo: UIImage!
    var jotController: JotViewController!
    var isDrag: Bool!
    var dragEnable = Drag.Circle
    @IBOutlet var imagePreviewView: UIImageView!
    @IBOutlet var textEditButton: UIButton!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var sendBlinkButton: UIButton!
    
    lazy var blurView: UIVisualEffectView! = {
        let darkBlur = UIBlurEffect(style: .Dark)
        let darkBlurView = UIVisualEffectView(effect: darkBlur)
        return darkBlurView
    }()
    
    lazy var holeView: HoleView! = {
        var holeView = HoleView(frame: CGRectMake(0, 0, 150, 150))
        holeView.image = self.photo
        return holeView
    }()
    
    @IBAction func backController(sender: AnyObject) {
        PBJVision.sharedInstance().startPreview()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func manageSubView() {
        view.bringSubviewToFront(blurView)
        view.bringSubviewToFront(jotController.view)
        view.bringSubviewToFront(holeView)
        view.bringSubviewToFront(textEditButton)
        view.bringSubviewToFront(backButton)
        view.bringSubviewToFront(sendBlinkButton)
    }
    
    override func viewDidAppear(animated: Bool) {
        manageSubView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(holeView)
        view.addSubview(blurView)
        blurView.mas_makeConstraints { (make: MASConstraintMaker!) -> Void in
            make.edges.equalTo()(self.view)
        }
        
        imagePreviewView.image = photo
        imagePreviewView.contentMode = UIViewContentMode.ScaleAspectFill
        imagePreviewView.layer.masksToBounds = true
        
        jotController = JotViewController()
        jotController.delegate = self
        jotController.view.frame = self.view.bounds
        jotController.view.backgroundColor = UIColor.clearColor()
        jotController.fitOriginalFontSizeToViewWidth = true
        
        addChildViewController(jotController)
        view.addSubview(jotController.view)
        jotController.didMoveToParentViewController(self)
        
        textEditButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { (_) -> Void in
            self.jotController.state = JotViewState.EditingText
        }
        
        sendBlinkButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { (_) -> Void in
            let textImage = self.renderTextDrawer()
            let text = self.jotController.textString
            
            self.performSegueWithIdentifier("selectFriendSegue", sender: nil)
        }
        
        manageSubView()
    }
}

extension CameraPreviewViewController: JotViewControllerDelegate {
    
    func renderTextDrawer() -> UIImage {
        return jotController.renderImage()
    }
}

extension CameraPreviewViewController {
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let position = touch!.locationInView(self.view)
        
        if self.dragEnable == Drag.None {
            return
        }
        self.isDrag = false
        
        if CGRectContainsPoint(self.holeView.frame, position) {
            self.isDrag = true
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if self.isDrag == true {
            let touch = touches.first
            let position = touch!.locationInView(self.view)
            
            holeView.tapEnable = false
            switch self.dragEnable {
            case Drag.Circle:
                var newPosition = CGPointMake(position.x - self.holeView.frame.size.width / 2, position.y - self.holeView.frame.size.height / 2)
                
                if newPosition.x < -self.holeView.frame.size.width / 2 {
                    newPosition.x = -self.holeView.frame.size.width / 2
                }
                if newPosition.x > self.view.frame.size.width - self.holeView.frame.width / 2 {
                    newPosition.x = self.view.frame.size.width - self.holeView.frame.width / 2
                }
                
                if newPosition.y < -self.holeView.frame.size.height / 2 {
                    newPosition.y = -self.holeView.frame.size.height / 2
                }
                if newPosition.y > self.view.frame.size.height - self.holeView.frame.size.height / 2 {
                    newPosition.y = self.view.frame.size.height - self.holeView.frame.height / 2
                }
                
                self.holeView.frame.origin = newPosition
                self.holeView.updatePostion()
                
            default: return
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.isDrag = false
        holeView.tapEnable = true
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        self.isDrag = false
        holeView.tapEnable = true
    }
}
