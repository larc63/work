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
        
        FlickrClient.sharedInstance().getPhotoSetForLocation("-0.1275920", lat: "51.5034070"){(success, errorString, photosArray) -> Void in
            if(success){
                var count = 0;
                for p in photosArray! {
                    let d = p as! NSDictionary
                    let id = d["id"] as! String
                    let title = d["title"] as! String
                    let newPhoto = Photo()
                    newPhoto.id = id
                    newPhoto.title = title
                    self.photos.append(newPhoto)
                    if (count < 1){
                        FlickrClient.sharedInstance().getPhotoForId(id){(success, errorString, photoData) -> Void in
                            if(success){
                                //TODO: modify the Photo object to use the url
                            }else{
                                //TODO: hanle error here
                            }
                        };
                    }
                    count++
                }
                self.performSegueWithIdentifier("showPhotosForPin", sender: nil)
            }else{
                //                TODO: handle error
            }
        }
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
        mapView.addAnnotation(annot)
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        print("called didSelectAnnotationView")
    }
}

