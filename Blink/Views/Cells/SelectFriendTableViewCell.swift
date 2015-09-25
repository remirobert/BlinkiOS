//
//  SelectFriendTableViewCell.swift
//  Blink
//
//  Created by Remi Robert on 25/09/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

import UIKit
import Parse

class SelectFriendTableViewCell: UITableViewCell {

    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var selectionStatusImage: UIImageView!
    
    func selectFriend() {
        selectionStatusImage.image = UIImage(named: "icon-friend-ticked")
    }
    
    func unselectFriend() {
        selectionStatusImage.image = UIImage(named: "icon-friend-untick")
    }
    
    func initCell(friend: PFObject) {
        if let username = friend["trueUsername"] as? String {
            usernameLabel.text = username
        }
    }
}
