//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Luis Antonio Rodriguez on 11/25/15.
//  Copyright © 2015 Luis Antonio Rodriguez. All rights reserved.
//

import Foundation

class  UdacityClient {
    
    // MARK: Authentication (POST) Method
    func authenticateWithViewController(hostViewController: LoginViewController, completionHandler: (success: Bool, errorString: String?) -> Void) {
        WebServiceHelpers.sharedInstance().taskForPOSTMethod("https://www.udacity.com/api/", method: "session", parameters: [:], jsonBody: ["udacity":["username":hostViewController.username.text!, "password": hostViewController.password.text!]]) { (result, errosString) in
            print("result = \(result)")
            let account = result["account"] as! NSDictionary
            let registered = account["registered"] as! Bool
            if(registered){
                completionHandler(success: true, errorString: nil)
            }else{
                //TODO: report the error to the user
            }
        }
    }
    
    func logoutUser(completionHandler: (success: Bool, errorString: String?) -> Void ){
        WebServiceHelpers.sharedInstance().taskForDELETEMethod("https://www.udacity.com/api/", method: "session", parameters: [:], jsonBody: [:]) {(result, errorString) in
            print("result = \(result)")
            completionHandler(success: true, errorString: nil)
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