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
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        signUpLabel.url = "https://www.udacity.com/account/auth#!/signin"
        loginButton.enabled = false
        activityIndicator.hidden = true
        
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
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if let u = username.text {
            if let p = password.text {
                if u.characters.count + p.characters.count > 0 {
                    loginButton.enabled = true
                    return true
                }
            }
        }
        loginButton.enabled = false
        return true
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
        view.endEditing(true)
    }
    
    //MARK: the login logic
    
    func doLogin(){
        loginButton.enabled = false
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        UdacityClient.sharedInstance().authenticateWithViewController(self) { (success, errorString) in
            if success {
                print("login successful")
                self.completeLogin()
            } else {
                print("login failed")
                self.loginButton.enabled = true
                self.activityIndicator.hidden = true
                self.activityIndicator.stopAnimating()
                if let errorString = errorString {
                    Helpers.showAlert(self, message: errorString)
                }else{
                    Helpers.showAlert(self, message: "An error occurred while logging you in")
                }
            }
        }
    }
    
    func completeLogin() {
        loginButton.enabled = false
        ParseClient.sharedInstance().getUserLocations(){(success, errorString, values) in
            self.loginButton.enabled = true
            self.activityIndicator.hidden = true
            self.activityIndicator.stopAnimating()
            if success {
                //This call will convert results into an array that's stored in the UdacityStudents class
                UdacityStudents.studentsFromResults(values as! [[String:AnyObject]])
                dispatch_async(dispatch_get_main_queue(), {
                    let nav = self.storyboard!.instantiateViewControllerWithIdentifier("MainNavigationController") as! UINavigationController
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
        doLogin()
    }
    
}

