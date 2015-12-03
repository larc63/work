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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
                    let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MainNavigationController") as! UINavigationController
                    self.presentViewController(controller, animated: true, completion: nil)
                })
            }else {
                //TODO: display the error to the user
                print("An error occurred \(errorString)")
            }
        }
    }
    

    @IBAction func loginButtonTouched(sender: AnyObject) {
        UdacityClient.sharedInstance().authenticateWithViewController(self) { (success, errorString) in
            if success {
                print("login successful")
                self.completeLogin()
            } else {
                //TODO: display the error to the user
                //                self.displayError(errorString)
                print("login failed")
            }
        }
    }

}

