//
//  FavoriteRecipesViewController.swift
//  RecipeRandomizer
//
//  Created by Luis Antonio Rodriguez on 2/21/16.
//  Copyright © 2016 Luis Antonio Rodriguez. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class FavoriteRecupesViewController : RecipeSearchResultsController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    override func viewWillDisappear(animated: Bool) {
        navigationController?.navigationBarHidden = false
        super.viewWillDisappear(animated)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        recipes = fetchAllRecipes()
        navigationController?.navigationBarHidden = true
        collectionView.reloadData()
        if recipes.count == 0{
                let alert = UIAlertController(title: "D'oh!", message: "You don't have any favorite recipes yet, go find some!", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){action in
                }
                alert.addAction(okAction)
                self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    
    func fetchAllRecipes() -> [Recipe] {
        // Create the Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "Recipe")
        // Execute the Fetch Request
        var persistentRecipes:[PersistedRecipe]
        do {
            persistentRecipes = try sharedContext.executeFetchRequest(fetchRequest) as! [PersistedRecipe]
        } catch  let error as NSError {
            print("Error in fetchAllRecipes(): \(error)")
            return [Recipe]()
        }
        
        var retVal = [Recipe]()
        for p in persistentRecipes{
            let dictionary: [String : AnyObject] = [
                RecipeKeys.ID : p.id,
                RecipeKeys.TITLE : p.title,
                RecipeKeys.SOURCE_URL : p.source_url,
                RecipeKeys.IMAGE_URL : p.image_url,
                RecipeKeys.PUBLISHER : p.publisher,
                RecipeKeys.INGREDIENTS : p.ingredients
            ]
            let recipeToAdd = Recipe(dictionary: dictionary)
            recipeToAdd.isFavorite = true
            retVal.append(recipeToAdd)
        }
        return retVal
    }
}