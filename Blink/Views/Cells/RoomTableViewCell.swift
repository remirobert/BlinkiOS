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
    
    func initRoomCell(room: PFObject, indexPath: NSIndexPath) {
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.titleRoom.text = room["title"] as? String
        
        self.detailCell.text = nil

        if let username = room["username"] as? String {
            self.detailCell.text = username
        }
        
        self.numberUsers.text = "0"
        if let numberMedias = room["numberMedias"] as? Int {
            self.numberUsers.text = "\(numberMedias)"
        }
        
        self.backgroundColor = Colors.colorForRow(indexPath.row)
        self.titleRoom.textColor = UIColor.whiteColor()
        self.detailCell.textColor = UIColor.whiteColor()
        self.numberUsers.textColor = Colors.secondColorForRow(indexPath.row)
    }
}
