//
//  MainViewController.swift
//  OnTheMap
//
//  Created by Luis Antonio Rodriguez on 11/25/15.
//  Copyright © 2015 Luis Antonio Rodriguez. All rights reserved.
//

import Foundation
import UIKit

class MainviewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem (
            title: "Log Out",
            style: UIBarButtonItemStyle.Plain,
            target: self,
            action: "logOut")
    }
    
    func popToLoginScreen(){
        dispatch_async(dispatch_get_main_queue(), {
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController") 
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }
    
    func logOut() {
        UdacityClient.sharedInstance().logoutUser(){ (success, errorString) in
            if success {
                print("logout successful")
                self.popToLoginScreen()
            } else {
                print("logout failed")
                self.popToLoginScreen()
            }
        }
    }
}
