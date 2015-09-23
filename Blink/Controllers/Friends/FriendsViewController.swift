//
//  FriendsViewController.swift
//  Blink
//
//  Created by Remi Robert on 22/09/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

import UIKit
import Parse
import ReactiveCocoa

class FriendsViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    var friends = Array<PFUser>()
    
    @IBAction func exitController(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func fetchData(cachePolicy: PFCachePolicy = PFCachePolicy.NetworkOnly) {
        Friend.friends(cachePolicy).subscribeNext({ (next: AnyObject!) -> Void in
            
            self.friends.removeAll()
            if let users = next as? [PFUser] {
                self.friends = users
            }
            self.tableView.reloadData()
            
            }, error: { (error: NSError!) -> Void in
                
            }) { () -> Void in }
    }
    
    override func viewDidAppear(animated: Bool) {
        fetchData(.CacheThenNetwork)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        tableView.registerNib(UINib(nibName: "FriendTableViewCell", bundle: nil), forCellReuseIdentifier: "friendCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsMultipleSelectionDuringEditing = false
    }
}

extension FriendsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("friendCell") as! FriendTableViewCell
        
        cell.initCell(friends[indexPath.row])
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
}

extension FriendsViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let friend = friends[indexPath.row]
            
            Friend.removeFriend(friend).subscribeNext({ (next: AnyObject!) -> Void in
                self.fetchData()
                }, error: { (error: NSError!) -> Void in
                    print("error removing friend: \(error)")
                }, completed: { () -> Void in
            })
        }
    }
}