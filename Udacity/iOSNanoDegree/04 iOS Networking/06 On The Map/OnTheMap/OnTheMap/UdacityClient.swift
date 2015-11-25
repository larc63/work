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
    func authenticateWithViewController(hostViewController: UIViewController, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        /* Chain completion handlers for each request so that they run one after the other */
//        self.loginWithToken() { (success, requestToken, errorString) in
//            
//            if success {
//                
//                self.loginWithToken(requestToken, hostViewController: hostViewController) { (success, errorString) in
//                    
//                    if success {
//                        self.getSessionID(requestToken) { (success, sessionID, errorString) in
//                            
//                            if success {
//                                
//                                /* Success! We have the sessionID! */
//                                self.sessionID = sessionID
//                                
//                                self.getUserID() { (success, userID, errorString) in
//                                    
//                                    if success {
//                                        
//                                        if let userID = userID {
//                                            
//                                            /* And the userID 😄! */
//                                            self.userID = userID
//                                        }
//                                    }
//                                    
//                                    completionHandler(success: success, errorString: errorString)
//                                }
//                            } else {
//                                completionHandler(success: success, errorString: errorString)
//                            }
//                        }
//                    } else {
//                        completionHandler(success: success, errorString: errorString)
//                    }
//                }
//            } else {
//                completionHandler(success: success, errorString: errorString)
//            }
//        }
    }
    

    /* This function opens a TMDBAuthViewController to handle Step 2a of the auth flow */
    func loginWithToken(requestToken: String?, hostViewController: UIViewController, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
//        let authorizationURL = NSURL(string: "\(TMDBClient.Constants.AuthorizationURL)\(requestToken!)")
//        let request = NSURLRequest(URL: authorizationURL!)
//        let webAuthViewController = hostViewController.storyboard!.instantiateViewControllerWithIdentifier("TMDBAuthViewController") as! TMDBAuthViewController
//        webAuthViewController.urlRequest = request
//        webAuthViewController.requestToken = requestToken
//        webAuthViewController.completionHandler = completionHandler
//        
//        let webAuthNavigationController = UINavigationController()
//        webAuthNavigationController.pushViewController(webAuthViewController, animated: false)
//        
//        dispatch_async(dispatch_get_main_queue(), {
//            hostViewController.presentViewController(webAuthNavigationController, animated: true, completion: nil)
//        })
    }
}