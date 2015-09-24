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
    var friends = Array<PFObject>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
    }
}

extension SelectFriendsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
    }
}