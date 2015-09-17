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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.segmentFeed.rac_signalForControlEvents(UIControlEvents.EditingChanged).subscribeNext { (_) -> Void in
            
        }
        
        self.newBlinkButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { (_) -> Void in
            
        }
    }
}
