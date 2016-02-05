//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Luis Antonio Rodriguez on 2/1/16.
//  Copyright © 2016 Luis Antonio Rodriguez. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class PhotoAlbumViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, NSFetchedResultsControllerDelegate {
    var pin:Pin?
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var newCollectionButton: UIButton!
    // MARK: View lifecycle methods
    override func viewDidLoad() {
        let predicate = NSPredicate(format: "pin == %@", pin!)
        fetchedResultsController.fetchRequest.predicate = predicate
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Unresolved error \(error)")
            abort()
        }
        
        fetchedResultsController.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            collectionView?.insertItemsAtIndexPaths([newIndexPath!])
        case .Delete:
            collectionView?.deleteItemsAtIndexPaths([indexPath!])
        default:
            return
        }
    }
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }

    // MARK: - Fetched Results Controller
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        // Create the fetch request
        let fetchRequest = NSFetchRequest(entityName: "Photo")
        // Add a sort descriptor.
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        // Create the Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        // Return the fetched results controller. It will be the value of the lazy variable
        return fetchedResultsController
    } ()
    
    // MARK: Collection View Related methods
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoAlbumViewCell", forIndexPath: indexPath) as! PhotoAlbumViewCell
        let photo = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Photo
        // set the background to be rounded
        cell.backGround.layer.cornerRadius = 10.0
        cell.backGround.clipsToBounds = true
        
        cell.title.text = photo.title
        
        if photo.image != nil {
            cell.imageView.image = photo.image!
            cell.activityIndicator.stopAnimating()
        }else{
            cell.imageView.image = UIImage(named: "placeholder")
            cell.activityIndicator.startAnimating()
            var url:String = ""
            self.sharedContext.performBlockAndWait(){
                url = photo.thumbnailUrl
            }
            if url != "" {
                let task = WebServiceHelpers.sharedInstance().taskForImageWithUrl(url){ (imageData, error) -> Void in
                    if let data = imageData {
                        dispatch_async(dispatch_get_main_queue()) {
                            let image = UIImage(data: data)
                            photo.image = image
                            cell.imageView.image = image
                            cell.activityIndicator.stopAnimating()
                            cell.activityIndicator.hidden = true
                        }
                    }
                }
                cell.taskToCancelifCellIsReused = task
            }
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath){
        let photo = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Photo
        photo.pin = nil
        photo.image = nil
        sharedContext.deleteObject(photo)
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
    @IBAction func newCollectionPressed(sender: AnyObject) {
        for photo in pin!.photos {
            photo.pin = nil
            photo.image = nil
            sharedContext.deleteObject(photo)
            sharedContext.performBlockAndWait(){
                CoreDataStackManager.sharedInstance().saveContext()
            }
        }
        FlickrClient.sharedInstance().getPhotoSetForLocation(pin!, context: sharedContext){(success, errorString, photosArray) -> Void in
            if(success){
                self.sharedContext.performBlockAndWait(){
                    CoreDataStackManager.sharedInstance().saveContext()
                }
            }else{
                //                TODO: handle error
            }
        }
    }
}