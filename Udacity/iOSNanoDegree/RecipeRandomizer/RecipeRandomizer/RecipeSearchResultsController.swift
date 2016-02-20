//
//  RecipeSearchResultsController.swift
//  RecipeRandomizer
//
//  Created by Luis Antonio Rodriguez on 2/19/16.
//  Copyright © 2016 Luis Antonio Rodriguez. All rights reserved.
//

import Foundation
import UIKit

class RecipeSearchResultsController : UICollectionViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var recipes:[Recipe] = []
    
    override func viewDidLoad() {
//        let cv = view as! UICollectionView
//        cv.delegate = self
//        cv.dataSource = self
    }
    
    // MARK: Collection View Related methods
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        let sectionInfo = self.fetchedResultsController.sections![section]
//        return sectionInfo.numberOfObjects
        return recipes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("RecipeViewCell", forIndexPath: indexPath) as! RecipeResultsCell
        let  recipe = self.recipes[indexPath.row]
//        let photo = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Photo
        // set the background to be rounded
//        cell.backGround.layer.cornerRadius = 10.0
//        cell.backGround.clipsToBounds = true
        
        cell.title.text = recipe.title
        
//        if recipe.image != nil {
//            cell.image.image = recipe.image!
//            cell.activityIndicator.stopAnimating()
//        }else{
//            cell.image.image = UIImage(named: "placeholder")
//            cell.activityIndicator.startAnimating()
//            var url:String = ""
////            self.sharedContext.performBlockAndWait(){
////                url = photo.thumbnailUrl
////            }
//            if url != "" {
//                let task = WebServiceHelpers.sharedInstance().taskForImageWithUrl(url){ (imageData, error) -> Void in
////                    if let data = imageData {
////                        dispatch_async(dispatch_get_main_queue()) {
////                            let image = UIImage(data: data)
////                            photo.image = image
////                            cell.imageView.image = image
////                            cell.activityIndicator.stopAnimating()
////                            cell.activityIndicator.hidden = true
////                        }
////                    }
//                }
//                cell.taskToCancelifCellIsReused = task
//            }
//        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath){
//        let recipe = self.recipes[indexPath.row]
//        let photo = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Recipe
//        photo.pin = nil
//        photo.image = nil
//        sharedContext.deleteObject(photo)
//        CoreDataStackManager.sharedInstance().saveContext()
    }
}