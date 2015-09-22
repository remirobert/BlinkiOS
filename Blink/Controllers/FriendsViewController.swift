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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()

        Friend.friends().subscribeNext({ (next: AnyObject!) -> Void in
            
            self.friends.removeAll()
            if let users = next as? [PFUser] {
                self.friends = users
                self.tableView.reloadData()
            }
            
            }, error: { (error: NSError!) -> Void in
                
            }) { () -> Void in }
    }
}
