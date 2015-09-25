//
//  SelectFriendTableViewCell.swift
//  Blink
//
//  Created by Remi Robert on 25/09/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

import UIKit

class SelectTableViewCell: UITableViewCell {

    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var selectionStatusImage: UIImageView!
    
    func selectCell() {
        selectionStatusImage.image = UIImage(named: "icon-friend-ticked")
    }
    
    func deselectCell() {
        selectionStatusImage.image = UIImage(named: "icon-friend-untick")
    }
    
    func initCell(label: String) {
        usernameLabel.text = label
    }
}
