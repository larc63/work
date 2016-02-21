//
//  RecipeViewController.swift
//  RecipeRandomizer
//
//  Created by Luis Antonio Rodriguez on 2/20/16.
//  Copyright © 2016 Luis Antonio Rodriguez. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class RecipeViewController:UIViewController{
    var recipe : Recipe?
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var ingredients: UITextView!
    @IBOutlet weak var titleWidthContraint: NSLayoutConstraint!
    @IBOutlet weak var publisher: UILabel!
    @IBOutlet weak var likedButton: UIButton!
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    override func viewDidLoad() {
        titleWidthContraint.constant = view.frame.width - 100
        if let recipe = recipe{
            recipeImage.image = recipe.image
            recipeTitle.text = recipe.title
            var ingredientList = ""
            for ingredient in recipe.ingredients{
                ingredientList += "⚜ " + (ingredient ) + "\n"
            }
            if ingredientList == "" {
                ingredients.text = "Ingredients not available at the moment"
            }else{
                ingredients.text = ingredientList
            }
            publisher.text = recipe.publisher
            
            updateLikeButtonText()
        }
    }
    
    func updateLikeButtonText(){
        if let recipe = recipe{
            if recipe.isFavorite{
                likedButton.titleLabel!.text = "🍳"
                return
            }
        }
        likedButton.titleLabel!.text = "🔪"
    }
    
    @IBAction func likePressed(sender: AnyObject) {
        let predicate = NSPredicate(format: "id == %@", recipe!.id!)
        let fetchRequest = NSFetchRequest(entityName: "Recipe")
        fetchRequest.predicate = predicate
        var persistentRecipes:[PersistedRecipe]=[PersistedRecipe]()
        do {
            persistentRecipes = try sharedContext.executeFetchRequest(fetchRequest) as! [PersistedRecipe]
        } catch  let error as NSError {
            print("Error in likePressed(): \(error)")
        }
        
        if persistentRecipes.count > 0{
            ///delete
            sharedContext.performBlock { () -> Void in
                let recipe = persistentRecipes[0]
                self.sharedContext.deleteObject(recipe)
                CoreDataStackManager.sharedInstance().saveContext()
            }
            // unlike
            recipe!.isFavorite = false
        }else{
            sharedContext.performBlock { () -> Void in
                let persistedRecipe = PersistedRecipe(recipe: self.recipe!, context: self.sharedContext)
                for ingredient in self.recipe!.ingredients{
                    let persisted = PersistedIngredient(dictionary: [RecipeKeys.INGREDIENT: ingredient], context: self.sharedContext)
                    persisted.recipe = persistedRecipe
                }
                CoreDataStackManager.sharedInstance().saveContext()
            }
            recipe!.isFavorite = true
        }
        dispatch_async(dispatch_get_main_queue(),{
            self.updateLikeButtonText()
        })
    }
    
    @IBAction func linkPressed(sender: AnyObject) {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("FullRecipeViewController") as! FullRecipeViewController
        controller.requestURL = NSURLRequest(URL: NSURL(string: (recipe?.source_url)!)!)
        self.navigationController!.pushViewController(controller, animated: true)
    }
}