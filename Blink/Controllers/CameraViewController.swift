//
//  CameraViewController.swift
//  Blink
//
//  Created by Remi Robert on 24/09/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

import UIKit
import PBJVision

class CameraViewController: UIViewController {

    var previewLayer: AVCaptureVideoPreviewLayer!
    @IBOutlet var previewView: UIView!
    @IBOutlet var rotationCameraButton: UIButton!
    @IBOutlet var galleryCameraButton: UIButton!
    @IBOutlet var takePictureButton: UIButton!
    
    @IBAction func exitCameraController(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        previewLayer = PBJVision.sharedInstance().previewLayer
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewLayer.frame = previewView.bounds
        previewView.layer.addSublayer(previewLayer)
        
        let vision = PBJVision.sharedInstance()
        vision.delegate = self
        vision.cameraMode = PBJCameraMode.Photo
        vision.cameraOrientation = PBJCameraOrientation.Portrait
        vision.outputFormat = PBJOutputFormat.Widescreen
        
        takePictureButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { (_) -> Void in
            PBJVision.sharedInstance().capturePhoto()
        }
        
        galleryCameraButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { (_) -> Void in
            self.photoLibrary()
        }
        
        rotationCameraButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { (_) -> Void in
            self.rotationCamera()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "previewCameraSegue" {
            if let photo = sender as? UIImage {
                print(sender)
                (segue.destinationViewController as! CameraPreviewViewController).photo = photo
            }
        }
    }
}

//PBJVIsion extension
extension CameraViewController : PBJVisionDelegate {
    
    func vision(vision: PBJVision, capturedPhoto photoDict: [NSObject : AnyObject]?, error: NSError?) {
        if let photo = photoDict![PBJVisionPhotoImageKey] as? UIImage {
            self.performSegueWithIdentifier("previewCameraSegue", sender: photo)
        }
    }
    
    func rotationCamera() {
        if PBJVision.sharedInstance().cameraDevice == PBJCameraDevice.Front {
            PBJVision.sharedInstance().cameraDevice = PBJCameraDevice.Back
        }
        else {
            PBJVision.sharedInstance().cameraDevice = PBJCameraDevice.Front
        }
    }
}

//Gallery extension
extension CameraViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.performSegueWithIdentifier("previewCameraSegue", sender: image)
        }
    }
    
    func photoLibrary() {
        let controller = UIImagePickerController()
        controller.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        controller.delegate = self
        self.presentViewController(controller, animated: true, completion: nil)
    }
}
