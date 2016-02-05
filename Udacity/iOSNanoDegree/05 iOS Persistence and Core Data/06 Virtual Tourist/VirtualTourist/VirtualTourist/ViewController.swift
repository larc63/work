//
//  ViewController.swift
//  VirtualTourist
//
//  Created by Luis Antonio Rodriguez on 1/30/16.
//  Copyright © 2016 Luis Antonio Rodriguez. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class ViewController: UIViewController, UIGestureRecognizerDelegate, MKMapViewDelegate {
    var pins:[Pin] = []
    
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
        var annotations = [MKAnnotation]()
        pins = PinManager.fetchAllPins()
        for pin in pins{
            let lat = CLLocationDegrees(pin.latitude)
            let long = CLLocationDegrees(pin.longitude)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        // When the array is complete, we add the annotations to the map.
        mapView.addAnnotations(annotations)
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
        let longitude = annot.coordinate.longitude as Double
        let latitude = annot.coordinate.latitude as Double
        //check that the pin doesn't exist, if it des, return
        let filteredPins = PinManager.findPinFromLatitude(latitude, andLongitude: longitude)
        if filteredPins.count > 0 {
            return
        }
        
        let dictionary: [String : AnyObject] = [
            Pin.Keys.Longitude : longitude,
            Pin.Keys.Latitude : latitude
        ]
        // Now we create a new Person, using the shared Context
        let pinToBeAdded = Pin(dictionary: dictionary, context: sharedContext)
        
        // And add append the actor to the array as well
        self.pins.append(pinToBeAdded)
        CoreDataStackManager.sharedInstance().saveContext()
        mapView.addAnnotation(annot)
    }
        
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        print("called didSelectAnnotationView")
        let controller = storyboard!.instantiateViewControllerWithIdentifier("PhotoAlbumViewController") as! PhotoAlbumViewController
        let latitude =  view.annotation!.coordinate.latitude
        let longitude = view.annotation!.coordinate.longitude
        let filteredPins  = PinManager.findPinFromLatitude(latitude, andLongitude: longitude)
        if filteredPins.count != 1 {
            return
        }
        let pin = filteredPins[0]
        print("selected pin with latitude=\(pin.latitude) and longitude=\(pin.longitude)")
        if pin.photos.count == 0 {
            FlickrClient.sharedInstance().getPhotoSetForLocation(pin, context: sharedContext){(success, errorString, photosArray) -> Void in
                if(success){
                    self.sharedContext.performBlockAndWait(){
                        CoreDataStackManager.sharedInstance().saveContext()
                    }
                }else{
                    //                TODO: handle error
                }
            }
        }
        controller.pin = pin
        for a in mapView.annotations{
            mapView.deselectAnnotation(a, animated: false)
        }
        self.navigationController!.pushViewController(controller, animated: true)
    }
}

