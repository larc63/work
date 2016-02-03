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

class PhotoAlbumViewController: UICollectionViewController, NSFetchedResultsControllerDelegate {
    var pin:Pin?
    @IBOutlet var flowLayout: UICollectionViewFlowLayout!
    // MARK: View lifecycle methods
    override func viewDidLoad() {
        let space: CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
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
        //        navigationItem.rightBarButtonItem = UIBarButtonItem (
        //            title: "+",
        //            style: UIBarButtonItemStyle.Plain,
        //            target: self,
        //            action: "addAMeme")
        collectionView?.reloadData()
    }
    
    // MARK: Navigation button
    //    func addAMeme() {
    //                let memeMakerViewController = storyboard!.instantiateViewControllerWithIdentifier("MemeGeneratorViewController") as! MemeGeneratorViewController
    //                navigationController!.presentViewController(memeMakerViewController, animated: true, completion: nil)
    //    }
    
    //
    // This is the most important method. It adds and removes rows in the table, in response to changes in the data.
    //
    
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
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoAlbumViewCell", forIndexPath: indexPath) as! PhotoAlbumViewCell
        let photo = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Photo
        cell.title.text = photo.title
        
        if photo.image != nil {
            cell.imageView.image = photo.image!
        }else{
            cell.imageView.image = UIImage(named: "placeholder")
            FlickrClient.sharedInstance().getPhotoForId(photo.id){(success, errorString, photoSizes) -> Void in
                if(success){
                    if let photoSizes = photoSizes{
                        for size in photoSizes{
                            let label = size["label"] as! String?
                            if let label = label {
                                if label == "Square" {
                                    let url = size["source"] as! String?
                                    if let url = url{
                                        photo.thumbnailUrl = url
                                        CoreDataStackManager.sharedInstance().saveContext()
                                    }
                                }
                            }
                        }
                    }
                    
                    if photo.thumbnailUrl != "" {
                        let task = WebServiceHelpers.sharedInstance().taskForImageWithUrl(photo.thumbnailUrl){ (imageData, error) -> Void in
                            if let data = imageData {
                                dispatch_async(dispatch_get_main_queue()) {
                                    let image = UIImage(data: data)
                                    photo.image = image
                                    cell.imageView.image = image
                                }
                            }
                        }
                        cell.taskToCancelifCellIsReused = task
                    }
                }else{
                    //TODO: handle error here
                }
            };
        }
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath){
        let photo = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Photo
        sharedContext.deleteObject(photo)
        CoreDataStackManager.sharedInstance().saveContext()
    }
}