//
//  SignupNicknameViewController.swift
//  Blink
//
//  Created by Remi Robert on 17/09/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

import UIKit
import Parse
import ReactiveCocoa

class SignupNicknameViewController: UIViewController {

    @IBOutlet var nicknameTextField: UITextField!
    @IBOutlet var goButton: UIButton!
    var numberPhone: String!
    var codeValidation: String!
    
    func logUser() {
        User.loginUser(numberPhone).subscribeNext({ (_) -> Void in
            
            UIApplication.changeRootController("mainController")
            
            }, error: { (_) -> Void in
                self.presentViewController(Alert.displayError("Impossible to login"), animated: true, completion: nil)
            }) { () -> Void in
                
        }
    }
    
    func signupNewUser() {
        User.signupUser(numberPhone, username: nicknameTextField.text!).subscribeNext({ (next: AnyObject!) -> Void in
            
            if let success = next as? Bool where success {
                self.logUser()
                return
            }
            else {
                self.presentViewController(Alert.displayError("Impossible to create your account"), animated: true, completion: nil)
            }
            
            }, error: { (error: NSError!) -> Void in
                self.presentViewController(Alert.displayError("Impossible to create your account"), animated: true, completion: nil)
            }) { () -> Void in
                
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        goButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { (_) -> Void in
            
            self.goButton.enabled = false
            User.checkNicknameUser(self.nicknameTextField.text!).subscribeNext({ (next: AnyObject!) -> Void in
                print(next)
                if let exist = next as? Int where exist == 1 {
                    self.signupNewUser()
                    return
                }
                }, error: { (error: NSError!) -> Void in
                    self.presentViewController(Alert.displayError("the username already exist, please choose an antoher one"), animated: true, completion: nil)
                    return
                }, completed: { () -> Void in
                    self.goButton.enabled = true
            })
        }
    }
}
