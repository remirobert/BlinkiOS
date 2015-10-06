//
//  CameraViewController.swift
//  Blink
//
//  Created by Remi Robert on 24/09/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

import UIKit
import PBJVision
import Parse

class CameraViewController: UIViewController {

    var previewLayer: AVCaptureVideoPreviewLayer!
    @IBOutlet var previewView: UIView!
    @IBOutlet var rotationCameraButton: UIButton!
    @IBOutlet var galleryCameraButton: UIButton!
    @IBOutlet var takePictureButton: UIButton!
    @IBOutlet var labelRoom: UILabel!
    
    var room: PFObject?
    var parentController: UIViewController?
    var colorContent: ColorContent?
    
    @IBAction func exitCameraController(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserverForName("dismissCameraController", object: nil, queue: nil) { (_) -> Void in
            self.dismissViewControllerAnimated(false, completion: nil)
        }
        
        if let colorContent = colorContent {
            labelRoom.textColor = colorContent.color
            labelRoom.text = colorContent.content
        }
        else {
            labelRoom.text = ""
        }
        
        previewLayer = PBJVision.sharedInstance().previewLayer
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewLayer.frame = previewView.bounds
        previewView.layer.addSublayer(previewLayer)
        
        let vision = PBJVision.sharedInstance()
        vision.delegate = self
        vision.cameraDevice = PBJCameraDevice.Back
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
                (segue.destinationViewController as! CameraPreviewViewController).room = room
                (segue.destinationViewController as! CameraPreviewViewController).parentController = parentController
                (segue.destinationViewController as! CameraPreviewViewController).colorContent = colorContent
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
