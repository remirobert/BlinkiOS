//
//  MainFeedViewController.swift
//  Blink
//
//  Created by Remi Robert on 17/09/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

import UIKit
import Parse

class MainFeedViewController: UIViewController {

    @IBOutlet var segmentFeed: UISegmentedControl!
    @IBOutlet var newBlinkButton: UIButton!
    @IBOutlet var cameraButton: UIButton!
    @IBOutlet var tableView: UITableView!
    var rooms = Array<PFObject>()
    
    override func viewDidAppear(animated: Bool) {
        fetchRooms()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserverForName(Notification.RefreshFeed.rawValue, object: nil, queue: nil) { (_) -> Void in
            self.fetchRooms()
        }

        let username = PFUser.currentUser()!["trueUsername"] as? String
        print("current user connected : \(username)")
        
        tableView.registerNib(UINib(nibName: "RoomTableViewCell", bundle: nil), forCellReuseIdentifier: "cellRoom")
        tableView.dataSource = self
        
        segmentFeed.rac_signalForControlEvents(UIControlEvents.EditingChanged).subscribeNext { (_) -> Void in
            
        }
        
        newBlinkButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { (_) -> Void in
            
        }
        
        cameraButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { (_) -> Void in
            self.performSegueWithIdentifier("cameraSegue", sender: nil)
        }
    }
}

extension MainFeedViewController {
    
    func fetchRooms() {
        Room.fetchRooms().subscribeNext({ (next: AnyObject!) -> Void in
            
            if let rooms = next as? [PFObject] {
                self.rooms = rooms
                print("rooms fetched : \(rooms)")
                self.tableView.reloadData()
            }
            
            }) { (error: NSError!) -> Void in
                print("error fetch rooms : \(error)")
        }
    }
}

extension MainFeedViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellRoom") as! RoomTableViewCell
        
        cell.initRoomCell(rooms[indexPath.row])
        return cell
    }
}
