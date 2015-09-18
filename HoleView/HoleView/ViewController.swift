//
//  ViewController.swift
//  HoleView
//
//  Created by Remi Robert on 17/09/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let holeView = HoleView(frame: UIScreen.mainScreen().bounds)        
        self.view.addSubview(holeView)

    }

}

