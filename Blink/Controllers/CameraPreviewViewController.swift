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

class CameraPreviewViewController: UIViewController {

    var photo: UIImage!
    var jotController: JotViewController!
    var holeView: UIView!
    @IBOutlet var imagePreviewView: UIImageView!
    @IBOutlet var textEditButton: UIButton!
    @IBOutlet var backButton: UIButton!
    
    @IBAction func backController(sender: AnyObject) {
        PBJVision.sharedInstance().startPreview()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func manageSubView() {
        view.bringSubviewToFront(holeView)
        view.bringSubviewToFront(jotController.view)
        view.bringSubviewToFront(textEditButton)
        view.bringSubviewToFront(backButton)
    }
    
    override func viewDidAppear(animated: Bool) {
        manageSubView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        holeView = UIView()
        holeView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        view.addSubview(holeView)
        holeView.mas_makeConstraints { (make: MASConstraintMaker!) -> Void in
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
        manageSubView()
    }
}

extension CameraPreviewViewController: JotViewControllerDelegate {
    
    
}
