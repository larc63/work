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
        return photos.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoAlbumViewCell", forIndexPath: indexPath) as! PhotoAlbumViewCell
        let photo = photos[indexPath.row]
        cell.title.text = photo.title!
        
        if let localImage = photo.image{
            cell.imageView.image = localImage
        }else{
            cell.imageView.image = UIImage(named: "placeholder")
            FlickrClient.sharedInstance().getImage(photo.id!){ (success, errorString, data) -> Void in
                
            }
            //            let task = TheMovieDB.sharedInstance().taskForImageWithSize(size, filePath: actor.imagePath!) { (imageData, error) -> Void in
            //
            //                if let data = imageData {
            //                    dispatch_async(dispatch_get_main_queue()) {
            //                        let image = UIImage(data: data)
            //                        actor.image = image
            //                        cell.actorImageView.image = image
            //                    }
            //                }
            //            }
            //
            //            cell.taskToCancelifCellIsReused = task
        }
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
        //TODO: show the full res version? maybe?
    }
}