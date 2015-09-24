//
//  SelectFriendsViewController.swift
//  Blink
//
//  Created by Remi Robert on 24/09/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

import UIKit
import Parse
import ReactiveCocoa

class SelectFriendsViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var selectionLabel: UILabel!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var segmentSelection: UISegmentedControl!
    var friends = Array<PFObject>()
    var friendsSelected = Array<PFObject>()
    
    @IBAction func dismissSelection(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.registerNib(UINib(nibName: "FriendTableViewCell", bundle: nil), forCellReuseIdentifier: "friendCell")
        tableView.allowsMultipleSelection = true
        
        Friend.friends(PFCachePolicy.CacheThenNetwork).subscribeNext({ (next: AnyObject!) -> Void in
            
            if let friends = next as? [PFObject] {
                self.friends = friends
                self.tableView.reloadData()
            }
            }, error: { (error: NSError!) -> Void in
                print("error to get friends list : \(error)")
            }) { () -> Void in
        }
    }
}

extension SelectFriendsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("friendCell") as! FriendTableViewCell
        
        cell.initCell(friends[indexPath.row])
        return cell
    }
}

extension SelectFriendsViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            cell.accessoryType = UITableViewCellAccessoryType.None
            removeFriendSelected(friends[indexPath.row])
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            addFriendSelected(friends[indexPath.row])
        }
    }
}

extension SelectFriendsViewController {
    
    func updateDisplayLabelSelected() {
        self.selectionLabel.text = "\(friendsSelected.count) selected"
    }
    
    func removeFriendSelected(friend: PFObject) {
        for var index = 0; index < friendsSelected.count; index++ {
            if friendsSelected[index] == friend {
                friendsSelected.removeAtIndex(index)
                updateDisplayLabelSelected()
                return
            }
        }
    }
    
    func addFriendSelected(friend: PFObject) {
        self.friendsSelected.append(friend)
        updateDisplayLabelSelected()
    }
}
