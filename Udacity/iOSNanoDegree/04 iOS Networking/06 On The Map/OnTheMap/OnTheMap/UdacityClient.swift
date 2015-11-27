//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Luis Antonio Rodriguez on 11/25/15.
//  Copyright © 2015 Luis Antonio Rodriguez. All rights reserved.
//

import Foundation
import UIKit

class  UdacityClient {
    
    // MARK: Authentication (GET) Methods
    /*
    Steps for Authentication...
    https://www.themoviedb.org/documentation/api/sessions
    
    Step 1: Create a new request token
    Step 2a: Ask the user for permission via the website
    Step 3: Create a session ID
    Bonus Step: Go ahead and get the user id 😎!
    */
    func authenticateWithViewController(hostViewController: LoginViewController, completionHandler: (success: Bool, errorString: String?) -> Void) {
        WebServiceHelpers.sharedInstance().taskForPOSTMethod("https://www.udacity.com/api/", method: "session", parameters: [:], jsonBody: ["udacity":["username":hostViewController.username.text!, "password": hostViewController.password.text!]]) { (result, errosString) in
            /// TODO: call the completionHandler
            print("result = \(result)")
            let account = result["account"] as! NSDictionary
            let registered = account["registered"] as! Bool
            if(registered){
                //TODO: transition to the main view controller
                completionHandler(success: true, errorString: nil)
            }else{
                //TODO: report the error to the user
            }
        }
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> UdacityClient {
        
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        
        return Singleton.sharedInstance
    }
}