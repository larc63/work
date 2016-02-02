//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Luis Antonio Rodriguez on 2/1/16.
//  Copyright © 2016 Luis Antonio Rodriguez. All rights reserved.
//

import Foundation
import UIKit

class PhotoAlbumViewController: UICollectionViewController{
    var photos:[Photo] = []
    
    @IBOutlet var flowLayout: UICollectionViewFlowLayout!
    // MARK: View lifecycle methods
    override func viewDidLoad() {
        let space: CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
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
    
    
    // MARK: Collection View Related methods
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30   //photos.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoAlbumViewCell", forIndexPath: indexPath) as! PhotoAlbumViewCell
        let photo = photos[indexPath.row]
        cell.title.text = photo.title!
        
        if photo.image != nil {
            cell.imageView.image = photo.image!
        }else{
            cell.imageView.image = UIImage(named: "placeholder")
            //TODO: move this to where the pin is set, this information can/should be available before getting to this point and have this view controller be a NSFetchedResultsController
            FlickrClient.sharedInstance().getPhotoForId(photo.id!){(success, errorString, photoSizes) -> Void in
                if(success){
                    //TODO: modify the Photo object to use the url
                    if let photoSizes = photoSizes{
                        for size in photoSizes{
                            let label = size["label"] as! String?
                            if let label = label {
                                if label == "Square" {
                                    let url = size["source"] as! String?
                                    if let url = url{
                                        photo.thumbnailURL = url
                                    }
                                }
                            }
                        }
                    }
                    
                    if let url = photo.thumbnailURL {
                        let task = WebServiceHelpers.sharedInstance().taskForImageWithUrl(url){ (imageData, error) -> Void in
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
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
        photos.removeAtIndex(indexPath.row)
        collectionView.reloadData()
    }
}