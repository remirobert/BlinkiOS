//
//  MediaDetailViewController.swift
//  Blink
//
//  Created by Remi Robert on 29/09/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

import UIKit
import Parse

class MediaDetailViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var collectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var replyButton: UIButton!
    
    var room: PFObject!
    var blinks = Array<PFObject>()
    
    @IBAction func backController(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserverForName("refreshBlink", object: nil, queue: nil) { (_) -> Void in
            self.fetchBlink()
        }
        
        collectionViewFlowLayout.itemSize = UIScreen.mainScreen().bounds.size
        collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        collectionView.pagingEnabled = true
        collectionView.registerNib(UINib(nibName: "MediaCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "mediaCell")
        collectionView.dataSource = self
        
        fetchBlink()
        
        replyButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { (_) -> Void in
            self.performSegueWithIdentifier("replyBlinkSegue", sender: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "replyBlinkSegue" {
            (segue.destinationViewController as! CameraViewController).room = room
            (segue.destinationViewController as! CameraViewController).parentController = self
        }
    }
}

extension MediaDetailViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return blinks.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("mediaCell", forIndexPath: indexPath) as! MediaCollectionViewCell
        
        let currentBlink = blinks[indexPath.row]
        cell.initBlinkContent(currentBlink)
        return cell
    }
}

extension MediaDetailViewController {
    
    func fetchBlink() {
        Room.fetchBlinkRoom(room).subscribeNext({ (next: AnyObject!) -> Void in
            
            if let blinks = next as? [PFObject] {
                self.blinks = blinks
                self.collectionView.reloadData()
            }
            
            }) { (error: NSError!) -> Void in
                print("error fetched blinks : \(error)")
        }
    }
}
