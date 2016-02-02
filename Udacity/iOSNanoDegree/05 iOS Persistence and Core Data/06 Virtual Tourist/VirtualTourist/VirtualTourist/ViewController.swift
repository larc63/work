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
        pins = fetchAllPins()
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
    
    //    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    //        if segue.identifier == "showPhotosForPin" {
    //            let nav = segue.destinationViewController as! UINavigationController
    //            let vc = nav.childViewControllers[0] as! PhotoAlbumViewController
    //            vc.photos = photos
    //        }
    //    }
    
    
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
        let filteredPins = findPinFromLatitude(latitude, andLongitude: longitude)
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
    // TODO: move to Pin class
    func fetchAllPins() -> [Pin] {
        // Create the Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "Pin")
        // Execute the Fetch Request
        do {
            return try sharedContext.executeFetchRequest(fetchRequest) as! [Pin]
        } catch  let error as NSError {
            print("Error in fetchAllPins(): \(error)")
            return [Pin]()
        }
    }
    
    
    //    func fetchPhotoCount() -> Int {
    //        // Create the Fetch Request
    //        let fetchRequest = NSFetchRequest(entityName: "Pin")
    //        // Execute the Fetch Request
    //        let error = NSErrorPointer()
    //        let count = sharedContext.countForFetchRequest(fetchRequest, error: error)
    //        if error == nil{
    //            return 0
    //        }else{
    //            return count
    //        }
    //    }
    //
    // TODO: move to Pin class
    func findPinFromLatitude(latitude: Double, andLongitude longitude: Double) -> [Pin]{
        let predicate = NSPredicate(format: "latitude == %lf AND longitude == %lf", latitude, longitude)
        let fetchRequest = NSFetchRequest(entityName: "Pin")
        fetchRequest.predicate = predicate
        do {
            return try sharedContext.executeFetchRequest(fetchRequest) as! [Pin]
        } catch  let error as NSError {
            print("Error in fetchAllPins(): \(error)")
            return [Pin]()
        }
    }
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        print("called didSelectAnnotationView")
        let latitude =  view.annotation!.coordinate.latitude
        let longitude = view.annotation!.coordinate.longitude
        let filteredPins  = findPinFromLatitude(latitude, andLongitude: longitude)
        if filteredPins.count != 1 {
            return
        }
        let pin = filteredPins[0]
        if pin.photos.count == 0 {
            FlickrClient.sharedInstance().getPhotoSetForLocation(longitude, lat: latitude){(success, errorString, photosArray) -> Void in
                if(success){
                    for p in photosArray! {
                        let d = p as! NSDictionary
                        let id = d["id"] as! String
                        let title = d["title"] as! String
                        FlickrClient.sharedInstance().getPhotoForId(id){(success, errorString, photoSizes) -> Void in
                            if(success){
                                if let photoSizes = photoSizes{
                                    for size in photoSizes{
                                        let label = size["label"] as! String?
                                        if let label = label {
                                            if label == "Square" {
                                                let url = size["source"] as! String?
                                                if let url = url{
                                                    print(url)
                                                    let dictionary: [String : AnyObject] = [
                                                        Photo.Keys.Id : id,
                                                        Photo.Keys.Title : title,
                                                        Photo.Keys.ThumbnailURL : url
                                                    ]
                                                    self.sharedContext.performBlockAndWait(){
                                                        let photo = Photo(dictionary: dictionary, context: self.sharedContext)
                                                        photo.pin = pin
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }else{
                                //TODO: handle error here
                            }
                        };
                    }
                    self.sharedContext.performBlockAndWait(){
                        CoreDataStackManager.sharedInstance().saveContext()
                    }
                }else{
                    //                TODO: handle error
                }
            }
        }
        self.performSegueWithIdentifier("showPhotosForPin", sender: nil)
    }
}

