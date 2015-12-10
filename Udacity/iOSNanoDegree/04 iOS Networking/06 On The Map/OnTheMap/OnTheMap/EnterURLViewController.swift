//
//  EnterURLViewController.swift
//  OnTheMap
//
//  Created by Luis Antonio Rodriguez on 12/8/15.
//  Copyright © 2015 Luis Antonio Rodriguez. All rights reserved.
//

import Foundation
import UIKit

class EnterURLViewController: UIViewController, UITextViewDelegate{
    var long:Double = 0, lat:Double = 0, radius:Double = 0
    var placeName: String? = nil
    @IBOutlet weak var urlText: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.Default){action in
        }
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //MARK: text view delegate overrides
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        textView.text = ""
        return true
    }
    
    @IBAction func submitButtonTapped(sender: AnyObject) {
        if Helpers.isValidURL(urlText.text) {
            showAlert("Please enter a valid URL")
            return
        }
        
        if let uniqueKey = UdacityClient.sharedInstance().userId {
            if let first_name = UdacityClient.sharedInstance().first_name {
                if let last_name = UdacityClient.sharedInstance().last_name {
                    if let mediaURL = urlText.text {
                        if let placeName = placeName {
                            ParseClient.sharedInstance().postUserLocation(uniqueKey, firstName: first_name, lastName: last_name, placeName: placeName, mediaURL: mediaURL, latitude: lat, longitude: long){ (success, errorString) in
                                if let errorString = errorString {
                                    self.showAlert(errorString)
                                } else {
                                    self.dismissViewControllerAnimated(true, completion: nil)
                                }
                            }
                        }else { //placeName
                            let placeName = "" /// setting the place name to an empty string if the geolocation fails to find it
                            ParseClient.sharedInstance().postUserLocation(uniqueKey, firstName: first_name, lastName: last_name, placeName: placeName, mediaURL: mediaURL, latitude: lat, longitude: long){ (success, errorString) in
                                if let errorString = errorString {
                                    self.showAlert(errorString)
                                } else {
                                    self.dismissViewControllerAnimated(true, completion: nil)
                                }
                            }
                        }
                    } else { //mediaURL
                        showAlert("Please enter a valid URL")
                    }
                }
            }
        }
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}