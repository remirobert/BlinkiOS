
//
//  InputTextfield.swift
//  Blink
//
//  Created by Remi Robert on 21/09/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

import UIKit

class InputTextfield: UITextField {

    func endEditingBarAction() {
        self.endEditing(true)
    }
    
    override func awakeFromNib() {
        let toolBar = UIToolbar(frame: CGRectMake(0, 0, frame.size.width, 50))
        toolBar.barStyle = UIBarStyle.Default
        toolBar.items = [UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: "endEditingBarAction")]
        toolBar.sizeToFit()
        inputAccessoryView = toolBar
    }
}
