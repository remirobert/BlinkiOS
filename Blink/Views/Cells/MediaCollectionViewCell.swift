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

    
    func initBlinkContent(blink: PFObject) {
        mediaContent.image = nil
        
        print(blink)
        
        if let fileContent = blink["image"] as? PFFile {
            fileContent.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) -> Void in
                if error != nil {
                    print("error fetch data content: \(error)")
                    return
                }
                if let dataImage = data, let image = UIImage(data: dataImage) {
                    self.mediaContent.image = image
                }
            })
        }
    }
}
