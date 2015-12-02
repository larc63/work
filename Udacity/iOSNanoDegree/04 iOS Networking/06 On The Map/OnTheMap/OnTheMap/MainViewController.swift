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
    
    func logOut() {
        if let navigationController = self.navigationController {
            navigationController.popToRootViewControllerAnimated(true)
        }
    }
}
