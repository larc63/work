//
//  ViewController.swift
//  VirtualTourist
//
//  Created by Luis Antonio Rodriguez on 1/30/16.
//  Copyright © 2016 Luis Antonio Rodriguez. All rights reserved.
//

import UIKit
import MapKit
class ViewController: UIViewController, UIGestureRecognizerDelegate, MKMapViewDelegate {

    let photos:[Photo] = []
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        /* Configure tap recognizer */
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
        longPressRecognizer.minimumPressDuration = 0.5
        longPressRecognizer.delegate = self
        mapView.addGestureRecognizer(longPressRecognizer)
        mapView.delegate = self
        
        FlickrClient.sharedInstance().getPhotoSetForLocation(self, long: "-0.1275920", lat: "51.5034070"){(success, errorString, photosArray) -> Void in
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return true
    }
    
    func handleLongPress(recognizer: UILongPressGestureRecognizer) {
        let touchPoint:CGPoint = recognizer.locationInView(mapView)// locationInView:self.mapView];
        let touchMapCoordinate: CLLocationCoordinate2D = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
        let annot = MKPointAnnotation()
        annot.coordinate = touchMapCoordinate
        mapView.addAnnotation(annot)
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        print("called didSelectAnnotationView")
    }
}

