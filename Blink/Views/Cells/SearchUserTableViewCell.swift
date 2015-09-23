//
//  SearchUserTableViewCell.swift
//  Blink
//
//  Created by Remi Robert on 22/09/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

import UIKit
import Parse

class SearchUserTableViewCell: UITableViewCell {

    @IBOutlet var switchFriend: UISwitch!
    @IBOutlet var labelUsername: UILabel!

    func initCellForUser(currentUser: PFObject, isFriend: Bool) {
        switchFriend.on = isFriend
        labelUsername.text = nil
        if let username = currentUser["trueUsername"] as? String {
            labelUsername.text = username
        }
    }
}
