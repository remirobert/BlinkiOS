//
//  SignupViewController.swift
//  Blink
//
//  Created by Remi Robert on 17/09/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {

    @IBOutlet var numberPhoneTextField: UITextField!
    @IBOutlet var sendValidationCodeButton: UIButton!
    @IBOutlet var validationCodeTextField: UITextField!
    @IBOutlet var nextButton: UIButton!
    var validationCode: String?
    
    @IBAction func cancelSignup(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendValidationCodeButton.enabled = false
        validationCodeTextField.enabled = false
        numberPhoneTextField.rac_textSignal().subscribeNext { (next: AnyObject!) -> Void in
            if let text = next as? String {
                self.sendValidationCodeButton.enabled = (text.characters.count > 0) ? true : false
            }
        }
        
        sendValidationCodeButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { (_) -> Void in
            
            self.sendValidationCodeButton.enabled = false
            self.validationCodeTextField.enabled = false
            Twilio.basicAuth(self.numberPhoneTextField.text!).subscribeNext({ (next: AnyObject!) -> Void in
                
                if let code = next as? String {
                    self.validationCode = code
                    self.validationCodeTextField.enabled = true
                }
                
                }, error: { (error: NSError!) -> Void in
                    self.presentViewController(Alert.displayError("Impossible to send the validation code"), animated: true, completion: nil)
                    self.sendValidationCodeButton.enabled = true
                    return
                }, completed: { () -> Void in
                    self.sendValidationCodeButton.enabled = true
            })
        }
        
        nextButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { (_) -> Void in
            if let code = self.validationCode where self.validationCodeTextField.text?.characters.count > 0 && self.validationCodeTextField.text == code {
                self.performSegueWithIdentifier("", sender: nil)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "" {
            if let controller = segue.destinationViewController as? SignupNicknameViewController {
                controller.codeValidation = validationCode
                controller.numberPhone = numberPhoneTextField.text!
            }
        }
    }
}
