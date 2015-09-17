//
//  LoginViewController.swift
//  Blink
//
//  Created by Remi Robert on 17/09/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

import UIKit
import ReactiveCocoa

class LoginViewController: UIViewController {
    
    @IBOutlet var phoneNumberTextField: UITextField!
    @IBOutlet var codeValidationTextField: UITextField!
    @IBOutlet var sendValidationCodeButton: UIButton!
    
    @IBAction func cancelLogin(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendValidationCodeButton.enabled = false
                
        phoneNumberTextField.rac_textSignal().subscribeNext { (text: AnyObject!) -> Void in
            if let text = text as? String {
                self.sendValidationCodeButton.enabled = (count(text) > 0) ? true : false
                print("text phone number signal : \(text) = \(text.length)")
            }
        }
        
        sendValidationCodeButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).doNext { (_) -> Void in
            print("send code clicked")
        }
    }
}
