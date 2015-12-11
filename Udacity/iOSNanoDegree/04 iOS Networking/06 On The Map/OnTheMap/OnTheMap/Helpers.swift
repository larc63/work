//
//  Helpers.swift
//  OnTheMap
//
//  Created by Luis Antonio Rodriguez on 12/10/15.
//  Copyright © 2015 Luis Antonio Rodriguez. All rights reserved.
//

import Foundation
import UIKit

class Helpers{
    static let urlMatchRegex = "^(https?:\\/\\/)?((([a-z0-9]+[a-z0-9\\.-]*)*[a-z0-9])+\\.)+((([a-z0-9]+[a-z0-9\\.-]*)*[a-z0-9])+)+\\/?"
    
    class func showAlert(viewController: UIViewController, message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.Default){action in
        }
        alert.addAction(okAction)
        dispatch_async(dispatch_get_main_queue()) {
            viewController.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    class func isValidURL(string: String) -> Bool{
        let range = string.rangeOfString(urlMatchRegex, options: .RegularExpressionSearch)
        return range != nil
    }
}