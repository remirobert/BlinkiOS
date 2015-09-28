//
//  RoomTableViewCell.swift
//  Sneak
//
//  Created by Remi Robert on 21/05/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit
import Parse

class RoomTableViewCell: UITableViewCell {

    @IBOutlet var numberUsers: UILabel!
    @IBOutlet var titleRoom: UILabel!
    @IBOutlet var detailCell: UILabel!
    
    func initRoomCell(room: PFObject) {
        self.titleRoom.text = room["title"] as? String
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleRoom.textColor = UIColor.whiteColor()
        self.detailCell.textColor = UIColor.whiteColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
