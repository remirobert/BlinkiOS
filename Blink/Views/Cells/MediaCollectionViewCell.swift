//
//  MediaCollectionViewCell.swift
//  Blink
//
//  Created by Remi Robert on 29/09/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

import UIKit
import Parse

class MediaCollectionViewCell: UICollectionViewCell {

    @IBOutlet var mediaContent: UIImageView!
    @IBOutlet var previewText: UIImageView!
    var previewContent: PreviewView!
    var blockHide: (() -> ())?
    var blockShow: (() -> ())?
    
    func updateDisplayView() {
        self.bringSubviewToFront(mediaContent)
        self.bringSubviewToFront(previewContent)
        self.bringSubviewToFront(previewText)
    }
    
    func initBlinkContent(blink: PFObject) {
        mediaContent.image = nil
        fetchFileContent(blink)
    }
}

extension MediaCollectionViewCell: PreviewViewDelegate {
    
    func displayPreview() {
        self.blockHide?()
        UIView.animateWithDuration(0.25) { () -> Void in
            self.previewText.alpha = 0
        }
    }
    
    func hideDisplay() {
        self.blockShow?()
        UIView.animateWithDuration(0.5, delay: 1, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
            self.previewText.alpha = 1
            }, completion: nil)
    }
}

extension MediaCollectionViewCell {
    
    func fetchFileContent(blink: PFObject) {
        if let fileContent = blink["image"] as? PFFile {
            fileContent.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) -> Void in
                if error != nil {
                    print("error fetch data content: \(error)")
                    return
                }
                
                if let dataImage = data, let image = UIImage(data: dataImage) {
                    self.fetchFileText(blink, image: image)
                }
            })
        }
    }
    
    func fetchFileText(blink: PFObject, image: UIImage) {
        if let fileText = blink["textDrawer"] as? PFFile {
            
            fileText.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) -> Void in
                
                if let dataImage = data, let imageText = UIImage(data: dataImage) {
                    if self.previewContent == nil {
                        self.previewContent = PreviewView()
                        self.previewContent.frame.origin = CGPointZero
                        self.previewContent.frame.size = UIScreen.mainScreen().bounds.size
                        
                    }
                    self.previewContent.loadContent(blink, photo: image, text: nil)
                    self.previewContent.delegate = self
                    self.mediaContent.image = image
                    self.contentView.insertSubview(self.previewContent, belowSubview: self.previewText)
                    self.previewText.image = imageText
                }
            })
        }
    }
}