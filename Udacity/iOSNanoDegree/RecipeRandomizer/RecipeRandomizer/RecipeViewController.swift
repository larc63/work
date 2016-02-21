//
//  RecipeViewController.swift
//  RecipeRandomizer
//
//  Created by Luis Antonio Rodriguez on 2/20/16.
//  Copyright © 2016 Luis Antonio Rodriguez. All rights reserved.
//

import Foundation
import UIKit

class RecipeViewController:UIViewController{
    var recipe : Recipe?
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var ingredients: UITextView!
    @IBOutlet weak var titleWidthContraint: NSLayoutConstraint!
    @IBOutlet weak var publisher: UILabel!
    
    override func viewDidLoad() {
        titleWidthContraint.constant = view.frame.width - 100
        if let recipe = recipe{
            recipeImage.image = recipe.image
            recipeTitle.text = recipe.title
            var ingredientList = ""
            for ingredient in recipe.ingredients!{
                ingredientList += "⚜ " + (ingredient as! String) + "\n"
            }
            ingredients.text = ingredientList
            publisher.text = recipe.publisher
        }
    }
    
    @IBAction func likePressed(sender: AnyObject) {
    }
    
    @IBAction func linkPressed(sender: AnyObject) {
    }
}