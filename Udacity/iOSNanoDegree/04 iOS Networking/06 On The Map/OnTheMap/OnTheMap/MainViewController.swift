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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "refresh")
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
    
    func refresh(){
        //let list = self.storyboard!.instantiateViewControllerWithIdentifier("ListView") as! TableViewController
        let map = self.storyboard!.instantiateViewControllerWithIdentifier("MapView") as! MapViewController
        //list.clearValues()
        map.clearValues()
        
        ParseClient.sharedInstance().getUserLocations(){(success, errorString, values) in
            //TODO store the user location daa somewhere
            if success {
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.studentLocations = UdacityStudent.studentsFromResults(values as! [[String:AnyObject]])
                self.refreshValues()
            }else {
                //TODO: display the error to the user
                print("An error occurred \(errorString)")
            }
        }
    }
    
    func refreshValues(){
        let list = self.storyboard!.instantiateViewControllerWithIdentifier("ListView") as! TableViewController
        let map = self.storyboard!.instantiateViewControllerWithIdentifier("MapView") as! MapViewController
        list.refreshValues()
        map.refreshValues()
        //map.view.setNeedsDisplay()
    }
}
