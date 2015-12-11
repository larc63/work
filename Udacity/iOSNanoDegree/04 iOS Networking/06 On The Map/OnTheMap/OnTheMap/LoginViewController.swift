//
//  ViewController.swift
//  OnTheMap
//
//  Created by Luis Antonio Rodriguez on 11/25/15.
//  Copyright © 2015 Luis Antonio Rodriguez. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var debugTextLabel: UILabel!
    @IBOutlet weak var signUpLabel: tappableLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        signUpLabel.url = "https://www.udacity.com/account/auth#!/signin"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func completeLogin() {
        ParseClient.sharedInstance().getUserLocations(){(success, errorString, values) in
            //TODO store the user location daa somewhere
            if success {
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.studentLocations = UdacityStudent.studentsFromResults(values as! [[String:AnyObject]])
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

