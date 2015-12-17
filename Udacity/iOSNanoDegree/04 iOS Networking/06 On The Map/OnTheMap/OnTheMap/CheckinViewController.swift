//
//  CheckinViewController.swift
//  OnTheMap
//
//  Created by Luis Antonio Rodriguez on 12/7/15.
//  Copyright © 2015 Luis Antonio Rodriguez. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class CheckinViewController: ViewControllerForKeyboard, UITextViewDelegate{
    var geocoder = CLGeocoder()
    var place:CLPlacemark? = nil
    // MARK: outlets
    @IBOutlet weak var searchText: UITextView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var labelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var label: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchButton.enabled = false
        activityIndicator.hidden = true
        navigationController?.setNavigationBarHidden(true, animated: true)
        nudgeAmount = labelTopConstraint.constant * 2
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToAddURLSegue" {
            let vc = segue.destinationViewController as! EnterURLViewController
            vc.coordinate = (place!.location?.coordinate)!
            vc.radius = (place!.location?.horizontalAccuracy)! + (place!.location?.verticalAccuracy)!
            vc.placeName = place!.name
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.Default){action in
        }
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func doSearch(){
        searchButton.enabled = false
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        geocoder.geocodeAddressString(searchText.text) { (placemarks: [CLPlacemark]?, error: NSError?) in
            self.activityIndicator.hidden = true
            self.activityIndicator.stopAnimating()
            if let error = error {
                self.searchButton.enabled = true
                // alert the user!
                self.showAlert("there was an error \(error)")
                print("there was an error \(error)")
            } else{
                if placemarks?.count > 0 {
                    self.place = placemarks?[0]
                    //goToAddURLSegue
                    self.performSegueWithIdentifier("goToAddURLSegue", sender: nil)
                }else{
                    self.searchButton.enabled = true
                    //alert the user that their search yielded no results
                    self.showAlert("the search yielded no results")
                    print("the search yielded no results")
                }
            }
        }
    }
    
    //MARK: text view delegate overrides
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        textView.text = ""
        return true
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            view.endEditing(true)
            doSearch()
            return false
        }
        
        if textView.text.characters.count > 0 {
            searchButton.enabled = true
        }else{
            searchButton.enabled = false
        }
        
        return true
    }
    
    // MARK: keyboard related methods
    
    func keyboardWillShow(notification: NSNotification){
        if !isKeyboardVisible{
            keyboardHeight = getKeyboardHeight(notification)
            print(keyboardHeight)
            view.frame.origin.y -= keyboardHeight
            labelTopConstraint.constant -= keyboardHeight
            isKeyboardVisible = true
        }
    }
    
    func keyboardWillHide(notification: NSNotification){
        if isKeyboardVisible{
            print(keyboardHeight)
            view.frame.origin.y += keyboardHeight
            labelTopConstraint.constant += keyboardHeight
            isKeyboardVisible = false
        }
    }
    
    //MARK: actions
    @IBAction func search(sender: AnyObject) {
        doSearch()
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}