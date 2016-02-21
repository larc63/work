//
//  PersistedIngredient.swift
//  RecipeRandomizer
//
//  Created by Luis Antonio Rodriguez on 2/20/16.
//  Copyright © 2016 Luis Antonio Rodriguez. All rights reserved.
//

import Foundation
import CoreData

class PersistedIngredient : NSManagedObject{
    @NSManaged var ingredient: String
    @NSManaged var recipe: PersistedRecipe
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String : AnyObject], context: NSManagedObjectContext) {
        let entity =  NSEntityDescription.entityForName("Ingredient", inManagedObjectContext: context)!
        super.init(entity: entity,insertIntoManagedObjectContext: context)
        ingredient = dictionary[RecipeKeys.INGREDIENT] as! String
    }
}