//
//  MainFeedViewController.swift
//  Blink
//
//  Created by Remi Robert on 17/09/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

import UIKit
import Parse
import ReactiveCocoa

class MainFeedViewController: UIViewController {

    @IBOutlet var segmentFeed: UISegmentedControl!
    @IBOutlet var newBlinkButton: UIButton!
    @IBOutlet var cameraButton: UIButton!
    @IBOutlet var tableView: UITableView!
    var refreshTableView: UIRefreshControl!
    var rooms = Array<PFObject>()
    var publicRooms = Array<PFObject>()
    
    override func viewDidAppear(animated: Bool) {
        fetchRooms()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let navigationBarAppearance = self.navigationController?.navigationBar
        navigationBarAppearance!.setBackgroundImage(UIImage(), forBarPosition: UIBarPosition.Any, barMetrics: UIBarMetrics.Default)
        navigationBarAppearance!.shadowImage = UIImage()

        
        NSNotificationCenter.defaultCenter().addObserverForName(Notification.RefreshFeed.rawValue, object: nil, queue: nil) { (_) -> Void in
            self.fetchRooms()
        }

        let username = PFUser.currentUser()!["trueUsername"] as? String
        print("current user connected : \(username)")
        
        tableView.registerNib(UINib(nibName: "RoomTableViewCell", bundle: nil), forCellReuseIdentifier: "cellRoom")
        tableView.dataSource = self
        tableView.delegate = self
        
        refreshTableView = UIRefreshControl()
        refreshTableView.addTarget(self, action: "fetchRooms", forControlEvents: UIControlEvents.ValueChanged)
        refreshTableView.backgroundColor = UIColor.clearColor()
        refreshTableView.tintColor = UIColor(red:0.99, green:0.36, blue:0.39, alpha:1)
        tableView.addSubview(refreshTableView)
        
        segmentFeed.rac_signalForControlEvents(UIControlEvents.ValueChanged).subscribeNext { (_) -> Void in
            self.tableView.reloadData()
        }
        
        newBlinkButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { (_) -> Void in
            
        }
        
        cameraButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { (_) -> Void in
            self.performSegueWithIdentifier("cameraSegue", sender: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailRoomSegue" {
            if let room = sender as? PFObject {
                (segue.destinationViewController as! MediaDetailViewController).room = room
            }
        }
    }
}

extension MainFeedViewController {
    
    func fetchRooms() {
        Room.fetchRooms().subscribeNext({ (next: AnyObject!) -> Void in
            
            if self.refreshTableView.refreshing {
                self.refreshTableView.endRefreshing()
            }
            
            if let rooms = next as? [PFObject] {
                self.rooms = rooms
                print("rooms fetched : \(rooms)")
                self.tableView.reloadData()
            }
            
            }) { (error: NSError!) -> Void in
                if self.refreshTableView.refreshing {
                    self.refreshTableView.endRefreshing()
                }
                print("error fetch rooms : \(error)")
        }
        
        Room.fetchPublicRoom().subscribeNext({ (next: AnyObject!) -> Void in
            
            if self.refreshTableView.refreshing {
                self.refreshTableView.endRefreshing()
            }
            
            if let rooms = next as? [PFObject] {
                self.publicRooms = rooms
                self.tableView.reloadData()
            }
            
            }) { (error: NSError!) -> Void in
                if self.refreshTableView.refreshing {
                    self.refreshTableView.endRefreshing()
                }
                print("error fetch rooms : \(error)")
        }
    }
}

extension MainFeedViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentFeed.selectedSegmentIndex == 0 {
            return rooms.count
        }
        return publicRooms.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellRoom") as! RoomTableViewCell
        
        if segmentFeed.selectedSegmentIndex == 0 {
            cell.initRoomCell(rooms[indexPath.row], indexPath: indexPath)
        }
        else {
            cell.initRoomCell(publicRooms[indexPath.row], indexPath: indexPath)
        }
        return cell
    }
}

extension MainFeedViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if segmentFeed.selectedSegmentIndex == 0 {
            performSegueWithIdentifier("detailRoomSegue", sender: rooms[indexPath.row])
        }
        else {
            performSegueWithIdentifier("detailRoomSegue", sender: publicRooms[indexPath.row])
        }
    }
}
