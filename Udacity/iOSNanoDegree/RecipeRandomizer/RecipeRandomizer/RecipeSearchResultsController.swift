//
//  RecipeSearchResultsController.swift
//  RecipeRandomizer
//
//  Created by Luis Antonio Rodriguez on 2/19/16.
//  Copyright © 2016 Luis Antonio Rodriguez. All rights reserved.
//

import Foundation
import UIKit

class RecipeSearchResultsController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var recipes:[Recipe] = []
    
    // MARK: Collection View Related methods
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 220)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("RecipeViewCell", forIndexPath: indexPath) as! RecipeResultsCell
        let  recipe = self.recipes[indexPath.row]
        
        cell.title.text = recipe.title
        cell.publisher.text = recipe.publisher
        
        if recipe.image != nil {
            cell.image.image = recipe.image!
            cell.activityIndicator.stopAnimating()
        }else{
            cell.image.image = UIImage(named: "ImagePlaceholder")
            cell.activityIndicator.startAnimating()
            if let url = recipe.image_url {
                let task = WebServiceHelpers.sharedInstance().taskForImageWithUrl(url){ (imageData, error) -> Void in
                    if let data = imageData {
                        dispatch_async(dispatch_get_main_queue()) {
                            let image = UIImage(data: data)
                            recipe.image = image
                            cell.image.image = image
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
        let recipe = self.recipes[indexPath.row]
        let controller = storyboard!.instantiateViewControllerWithIdentifier("RecipeViewController") as! RecipeViewController
        controller.recipe = recipe
        if recipe.ingredients.count == 0{
            Food2ForkClient.sharedInstance().getRecipeForId(recipe.id!) { (success, errorString, recipeData) -> Void in
                if success {
                    let ingredients = recipeData!["ingredients"] as! [String]
                    recipe.ingredients = ingredients
                    // perfom segue to view results
                    dispatch_async(dispatch_get_main_queue(),{
                        self.navigationController!.pushViewController(controller, animated: true)
                    })
                    
                }else{
                    print("meh")
                }
            }
        }
    }
}