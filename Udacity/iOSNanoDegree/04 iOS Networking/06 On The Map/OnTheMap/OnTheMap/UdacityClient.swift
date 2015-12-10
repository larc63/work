//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Luis Antonio Rodriguez on 11/25/15.
//  Copyright © 2015 Luis Antonio Rodriguez. All rights reserved.
//

import Foundation

class  UdacityClient {
    var userId:String? = nil
    var last_name:String? = nil
    var first_name:String? = nil
    // MARK: Authentication (POST) Method
    func authenticateWithViewController(hostViewController: LoginViewController, completionHandler: (success: Bool, errorString: String?) -> Void) {
        WebServiceHelpers.sharedInstance().taskForPOSTMethod("https://www.udacity.com/api/", method: "session", parameters: [:], jsonBody: ["udacity":["username":hostViewController.username.text!, "password": hostViewController.password.text!]], requestValues: [:], needsTruncating: true) { (result, errorString) in
            print("result = \(result)")
            let account = result["account"] as! NSDictionary
            let registered = account["registered"] as! Bool
            self.userId = account["key"] as! String?
            if registered{
                self.getUserData(){ (success, errorString) in
                    if (success){
                        completionHandler(success: true, errorString: nil)
                    } else {
                        completionHandler(success: false, errorString: errorString)
                    }
                }
            }else{
                //TODO: report the error to the user
                completionHandler(success: false, errorString: "An error occurred while logging in")
            }
        }
    }

    // MARK: User Data (GET) Method
    func getUserData(completionHandler: (success: Bool, errorString: String?) -> Void) {
        WebServiceHelpers.sharedInstance().taskForGETMethod("https://www.udacity.com/api/", method: "users/\(userId!)", parameters: [:], requestValues: [:], needsTruncating: true) { (result, errorString) in
            print("result = \(result)")
            let user = result["user"] as! NSDictionary
            self.last_name = user["last_name"] as! String?
            self.first_name = user["first_name"] as! String?
            if(user.count > 0){
                completionHandler(success: true, errorString: nil)
            }else{
                //TODO: report the error to the user
                completionHandler(success: false, errorString: "An error occurred while requesting your user data")
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