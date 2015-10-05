//
//  StartupViewController.swift
//  Blink
//
//  Created by Remi Robert on 17/09/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

import UIKit
import AVFoundation
import PBJVision

class StartupViewController: UIViewController {

    @IBOutlet var previewView: UIView!
    @IBOutlet var startupImageView: UIImageView!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var signupButton: UIButton!
    
    var previewLayer: AVCaptureVideoPreviewLayer!

    override func viewDidAppear(animated: Bool) {
        previewLayer = PBJVision.sharedInstance().previewLayer
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewLayer.frame = UIScreen.mainScreen().bounds
        previewView.layer.addSublayer(previewLayer)
        
        let vision = PBJVision.sharedInstance()
        vision.cameraMode = PBJCameraMode.Photo
        vision.cameraDevice = PBJCameraDevice.Front
        vision.cameraOrientation = PBJCameraOrientation.Portrait
        vision.outputFormat = PBJOutputFormat.Widescreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
