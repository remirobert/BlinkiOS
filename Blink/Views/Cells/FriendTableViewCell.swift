//
//  FriendTableViewCell.swift
//  Blink
//
//  Created by Remi Robert on 23/09/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

import UIKit
import Parse

class FriendTableViewCell: UITableViewCell {

    @IBOutlet var usernameLabel: UILabel!

    func initCell(friend: PFObject) {
        if let username = friend["trueUsername"] as? String {
            usernameLabel.text = username
        }
    }
}
