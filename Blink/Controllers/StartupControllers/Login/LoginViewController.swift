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
    @IBOutlet var loginButton: UIButton!
    var code: String?
    
    @IBAction func cancelLogin(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func logUser() {
        User.loginUser(phoneNumberTextField.text!).subscribeNext({ (_) -> Void in
            
            UIApplication.changeRootController("mainController")

            }, error: { (_) -> Void in
                self.presentViewController(Alert.displayError("Impossible to login"), animated: true, completion: nil)
            }) { () -> Void in
                
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneNumberTextField.text = "+8613162195325"
        sendValidationCodeButton.enabled = false
        phoneNumberTextField.rac_textSignal().subscribeNext { (next: AnyObject!) -> Void in
            if let text = next as? String {
                self.sendValidationCodeButton.enabled = (text.characters.count > 0) ? true : false
            }
        }

        sendValidationCodeButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { (_) -> Void in
            self.sendValidationCodeButton.enabled = false
            self.codeValidationTextField.enabled = false
            
            User.findUser(self.phoneNumberTextField.text!).subscribeNext({ (next: AnyObject!) -> Void in
                
                if let exist = next as? Int where exist == 1 {
                    Twilio.basicAuth(self.phoneNumberTextField.text!).subscribeNext({ (next: AnyObject!) -> Void in
                        if let code = next as? Int {
                            print("ativation code : \(code)")
                            self.code = "\(code)"
                            self.sendValidationCodeButton.enabled = true
                            self.codeValidationTextField.enabled = true
                            self.codeValidationTextField.alpha = 1
                            return
                        }
                        }, error: { (error: NSError!) -> Void in
                            return
                    })
                    
                }

                }, error: { (error: NSError!) -> Void in
                    print(error)
                }, completed: { () -> Void in
                    self.sendValidationCodeButton.enabled = true
            })
        }
        
        loginButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { (_) -> Void in
            if self.codeValidationTextField.text == self.code {
                self.logUser()
            }
        }
    }
}
