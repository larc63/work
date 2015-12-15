//
//  ViewController.swift
//  OnTheMap
//
//  Created by Luis Antonio Rodriguez on 11/25/15.
//  Copyright © 2015 Luis Antonio Rodriguez. All rights reserved.
//

import UIKit

class LoginViewController: ViewControllerForKeyboard, UITextFieldDelegate {
    @IBOutlet weak var udactityLogoTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var debugTextLabel: UILabel!
    @IBOutlet weak var signUpLabel: TappableLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        signUpLabel.url = "https://www.udacity.com/account/auth#!/signin"
        
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer?.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapRecognizer!)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
    }
    
    // Unsubscribe to keyboard notifications here
    override func viewDidDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: textview delegate methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1;
        // Try to find next responder
        let nextResponder=textField.superview?.viewWithTag(nextTag) as UIResponder!
        if (nextResponder != nil){
            // Found next responder, so set it.
            nextResponder?.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard
            textField.resignFirstResponder()
        }
        return false // We do not want UITextField to insert line-breaks.
    }
    
    
    // MARK: keyboard related methods
    
    func keyboardWillShow(notification: NSNotification){
        if !isKeyboardVisible{
            keyboardHeight = getKeyboardHeight(notification)
            print(keyboardHeight)
            view.frame.origin.y -= keyboardHeight
            udactityLogoTopConstraint.constant -= keyboardHeight
            isKeyboardVisible = true
        }
    }
    
    func keyboardWillHide(notification: NSNotification){
        if isKeyboardVisible{
            print(keyboardHeight)
            view.frame.origin.y += keyboardHeight
            udactityLogoTopConstraint.constant += keyboardHeight
            isKeyboardVisible = false
        }
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        print("End editing here")
        view.endEditing(true)
    }
    
    //MARK: the login logic
    func completeLogin() {
        ParseClient.sharedInstance().getUserLocations(){(success, errorString, values) in
            //TODO store the user location daa somewhere
            if success {
                //This call will convert results into an array that's stored in the UdacityStudents class
                UdacityStudents.studentsFromResults(values as! [[String:AnyObject]])
                dispatch_async(dispatch_get_main_queue(), {
                    self.debugTextLabel.text = ""
                    let nav = self.storyboard!.instantiateViewControllerWithIdentifier("MainNavigationController") as! UINavigationController
                    //                    nav.refresh()
                    self.presentViewController(nav, animated: true, completion: nil)
                })
            }else {
                if let errorString = errorString {
                    Helpers.showAlert(self, message: errorString)
                }else{
                    Helpers.showAlert(self, message: "An error occurred while logging you in")
                }
            }
        }
    }
    
    
    @IBAction func loginButtonTouched(sender: AnyObject) {
        UdacityClient.sharedInstance().authenticateWithViewController(self) { (success, errorString) in
            if success {
                print("login successful")
                self.completeLogin()
            } else {
                print("login failed")
                if let errorString = errorString {
                    Helpers.showAlert(self, message: errorString)
                }else{
                    Helpers.showAlert(self, message: "An error occurred while logging you in")
                }
            }
        }
    }
    
}

