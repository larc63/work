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
        
        let locationButton = UIBarButtonItem(image: UIImage(named: "MapMarker"), style: UIBarButtonItemStyle.Plain, target: self, action: "checkin")
        
        self.navigationItem.rightBarButtonItems = [ UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "refresh"),
            locationButton]
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func checkin(){
        let nav = self.storyboard!.instantiateViewControllerWithIdentifier("CheckinViewController")
        self.navigationController?.pushViewController(nav, animated: true)
    }
    
    func popToLoginScreen(){
        dispatch_async(dispatch_get_main_queue(), {
            self.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
    func logOut() {
        UdacityClient.sharedInstance().logoutUser(){ (success, errorString) in
            if success {
                print("logout successful")
                self.popToLoginScreen()
            } else {
                print("logout failed")
                if let errorString = errorString {
                Helpers.showAlert(self, message: errorString)
                } else {
                    Helpers.showAlert(self, message: "An error occurred while logging out")
                }
                self.popToLoginScreen()
            }
        }
    }
    
    func refresh(){
        ParseClient.sharedInstance().getUserLocations(){(success, errorString, values) in
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
        for vc in self.customizableViewControllers! {
            if vc is MapViewController{
                let v = vc as! MapViewController
                dispatch_async(dispatch_get_main_queue()) {
                    v.refreshValues()
                }
            }else if vc is TableViewController {
                let v = vc as! TableViewController
                dispatch_async(dispatch_get_main_queue()) {
                    v.refreshValues()
                }
            }
        }
    }
}
