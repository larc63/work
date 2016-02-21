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
        }
    }
    
    @IBAction func likePressed(sender: AnyObject) {
        sharedContext.performBlock { () -> Void in
            let persistedRecipe = PersistedRecipe(recipe: self.recipe!, context: self.sharedContext)
            for ingredient in self.recipe!.ingredients{
                let persisted = PersistedIngredient(dictionary: [RecipeKeys.INGREDIENT: ingredient], context: self.sharedContext)
                persisted.recipe = persistedRecipe
            }
            CoreDataStackManager.sharedInstance().saveContext()
        }
    }
    
    @IBAction func linkPressed(sender: AnyObject) {
    }
}