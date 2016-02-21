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
    
    
    @IBAction func likePressed(sender: AnyObject) {
    }
    
    @IBAction func linkPressed(sender: AnyObject) {
    }
}