//
//  EnterURLViewController.swift
//  OnTheMap
//
//  Created by Luis Antonio Rodriguez on 12/8/15.
//  Copyright © 2015 Luis Antonio Rodriguez. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class EnterURLViewController: ViewControllerForKeyboard, UITextViewDelegate, MKMapViewDelegate{
    var radius:Double = 0
    var coordinate:CLLocationCoordinate2D? = nil
    var placeName: String? = nil
    @IBOutlet weak var urlText: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        // Here we create the annotation and set its coordiate, title, and subtitle properties
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate!
        annotation.title = placeName!
        mapView.addAnnotation(annotation)
        print("setting radius to \(radius)")
        let oldRegion = mapView.regionThatFits(MKCoordinateRegionMakeWithDistance(coordinate!, radius*10, radius*10))
        mapView.setRegion(oldRegion, animated: true)
        // from the ViewControllerForKeyboard
        nudgeAmount = 300
    }
    
    func doPostInformation(){
        if !Helpers.isValidURL(urlText.text) {
            Helpers.showAlert(self, message:"Please enter a valid URL")
            return
        }
        
        if let uniqueKey = UdacityClient.sharedInstance().userId {
            if let first_name = UdacityClient.sharedInstance().first_name {
                if let last_name = UdacityClient.sharedInstance().last_name {
                    if let mediaURL = urlText.text {
                        if let placeName = placeName {
                            ParseClient.sharedInstance().postUserLocation(uniqueKey, firstName: first_name, lastName: last_name, placeName: placeName, mediaURL: mediaURL, latitude: (coordinate?.latitude)!, longitude: (coordinate?.longitude)!){ (success, errorString) in
                                if let errorString = errorString {
                                    Helpers.showAlert(self, message:errorString)
                                } else {
                                    dispatch_async(dispatch_get_main_queue()) {
                                        self.navigationController?.popToRootViewControllerAnimated(true)
                                    }
                                }
                            }
                        }else { //placeName
                            let placeName = "" /// setting the place name to an empty string if the geolocation fails to find it
                            ParseClient.sharedInstance().postUserLocation(uniqueKey, firstName: first_name, lastName: last_name, placeName: placeName, mediaURL: mediaURL, latitude: (coordinate?.latitude)!, longitude: (coordinate?.longitude)!){ (success, errorString) in
                                if let errorString = errorString {
                                    Helpers.showAlert(self, message:errorString)
                                } else {
                                    dispatch_async(dispatch_get_main_queue()) {
                                        self.navigationController?.popToRootViewControllerAnimated(true)
                                    }
                                }
                            }
                        }
                    } else { //mediaURL
                        Helpers.showAlert(self, message:"Please enter a valid URL")
                    }
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
            doPostInformation()
            return false
        }
        return true
    }
    
    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives.
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            //            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(NSURL(string: toOpen)!)
            }
        }
    }
    
    // MARK: keyboard related methods
    func keyboardWillShow(notification: NSNotification){
    }
    
    func keyboardWillHide(notification: NSNotification){
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        print("End editing here")
        view.endEditing(true)
    }
    
    // MARK: Actions for buttons
    
    @IBAction func submitButtonTapped(sender: AnyObject) {
        doPostInformation()
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}