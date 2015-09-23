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
    
    var actionSwitchBlock: ((state: Bool) -> Void)!
    
    func switchValueChanged() {
        if let block = actionSwitchBlock {
            block(state: switchFriend.on)
        }
    }
    
    func initCellForUser(currentUser: PFObject, isFriend: Bool) {
        switchFriend.on = isFriend
        switchFriend.addTarget(self, action: "switchValueChanged", forControlEvents: UIControlEvents.ValueChanged)
        labelUsername.text = nil
        if let username = currentUser["trueUsername"] as? String {
            labelUsername.text = username
        }
    }
}