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
    var photos:[Photo] = []
    
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showPhotosForPin" {
            let nav = segue.destinationViewController as! UINavigationController
            let vc = nav.childViewControllers[0] as! PhotoAlbumViewController
            vc.photos = photos
        }
    }
    
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return true
    }
    
    func handleLongPress(recognizer: UILongPressGestureRecognizer) {
        let touchPoint:CGPoint = recognizer.locationInView(mapView)// locationInView:self.mapView];
        let touchMapCoordinate: CLLocationCoordinate2D = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
        let annot = MKPointAnnotation()
        annot.coordinate = touchMapCoordinate
        
        //check that the pin doesn't exist, if it des, return
        
        let dictionary: [String : AnyObject] = [
            Pin.Keys.Longitude : annot.coordinate.longitude as NSNumber,
            Pin.Keys.Latitude : annot.coordinate.latitude as NSNumber
        ]
        // Now we create a new Person, using the shared Context
        let pinToBeAdded = Pin(dictionary: dictionary, context: sharedContext)

        // And add append the actor to the array as well
        self.pins.append(pinToBeAdded)
        
        CoreDataStackManager.sharedInstance().saveContext()
        
        mapView.addAnnotation(annot)
    }
    
    func fetchAllPins() -> [Pin] {
        // Create the Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "Pin")
        // Execute the Fetch Request
        do {
            return try sharedContext.executeFetchRequest(fetchRequest) as! [Pin]
        } catch  let error as NSError {
            print("Error in fetchAllActors(): \(error)")
            return [Pin]()
        }
    }

    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        print("called didSelectAnnotationView")
//        FlickrClient.sharedInstance().getPhotoSetForLocation("-0.1275920", lat: "51.5034070"){(success, errorString, photosArray) -> Void in
//            if(success){
//                var count = 0;
//                for p in photosArray! {
//                    let d = p as! NSDictionary
//                    let id = d["id"] as! String
//                    let title = d["title"] as! String
//                    let newPhoto = Photo()
//                    newPhoto.id = id
//                    newPhoto.title = title
//                    self.photos.append(newPhoto)
//                    if (count < 1){
//                        FlickrClient.sharedInstance().getPhotoForId(id){(success, errorString, photoSizes) -> Void in
//                            if(success){
//                                //TODO: modify the Photo object to use the url
//                                if let photoSizes = photoSizes{
//                                    for size in photoSizes{
//                                        let label = size["label"] as! String?
//                                        if let label = label {
//                                            if label == "Square" {
//                                                let url = size["source"] as! String?
//                                                if let url = url{
//                                                    newPhoto.thumbnailURL = url
//                                                }
//                                            }
//                                        }
//                                    }
//                                }
//                            }else{
//                                //TODO: hanle error here
//                            }
//                        };
//                    }
//                    count++
//                }
//                self.performSegueWithIdentifier("showPhotosForPin", sender: nil)
//            }else{
//                //                TODO: handle error
//            }
//        }
    }
}

