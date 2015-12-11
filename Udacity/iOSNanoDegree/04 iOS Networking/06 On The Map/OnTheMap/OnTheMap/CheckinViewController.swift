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

class CheckinViewController: UIViewController, UITextViewDelegate{
    var geocoder = CLGeocoder()
    var place:CLPlacemark? = nil
    // MARK: outlets
    @IBOutlet weak var searchText: UITextView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
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
    
    //MARK: text view delegate overrides
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        //TODO: remove me!!
        textView.text = "Ensenada, Mexico"
        return true
    }
    
    //MARK: actions
    @IBAction func search(sender: AnyObject) {
        geocoder.geocodeAddressString(searchText.text) { (placemarks: [CLPlacemark]?, error: NSError?) in
            if let error = error {
                // alert the user!
                self.showAlert("there was an error \(error)")
                print("there was an error \(error)")
            } else{
                if placemarks?.count > 0 {
                    self.place = placemarks?[0]
                    //goToAddURLSegue
                    self.performSegueWithIdentifier("goToAddURLSegue", sender: nil)
                }else{
                    //alert the user that their search yielded no results
                    self.showAlert("the search yielded no results")
                    print("the search yielded no results")
                }
            }
        }
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}