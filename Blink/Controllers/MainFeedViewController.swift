//
//  MainFeedViewController.swift
//  Blink
//
//  Created by Remi Robert on 17/09/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

import UIKit

class MainFeedViewController: UIViewController {

    @IBOutlet var segmentFeed: UISegmentedControl!
    @IBOutlet var newBlinkButton: UIButton!
    @IBOutlet var cameraButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentFeed.rac_signalForControlEvents(UIControlEvents.EditingChanged).subscribeNext { (_) -> Void in
            
        }
        
        newBlinkButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { (_) -> Void in
            
        }
        
        cameraButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { (_) -> Void in
            self.performSegueWithIdentifier("cameraSegue", sender: nil)
        }
    }
}
