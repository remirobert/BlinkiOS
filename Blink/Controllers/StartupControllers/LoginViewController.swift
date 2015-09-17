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
        phoneNumberTextField.rac_textSignal().subscribeNext { (next: AnyObject!) -> Void in
            if let text = next as? String {
                self.sendValidationCodeButton.enabled = (text.characters.count > 0) ? true : false
            }
        }

        sendValidationCodeButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { (_) -> Void in
            self.sendValidationCodeButton.enabled = false
            
            User.findUser(self.phoneNumberTextField.text!).subscribeNext({ (next: AnyObject!) -> Void in
                Twilio.basicLogin(self.phoneNumberTextField.text!).subscribeNext({ (next: AnyObject!) -> Void in
                    if let code = next as? String {
                        print("generated code : \(code)")
                    }
                    }, error: { (error: NSError!) -> Void in
                        print("error generation code : \(error)")
                    }, completed: { () -> Void in
                        self.sendValidationCodeButton.enabled = true
                })
                }, error: { (_) -> Void in
                    
                    self.sendValidationCodeButton.enabled = true
                }, completed: { () -> Void in
                    self.sendValidationCodeButton.enabled = true
            })
        }
    }
}
