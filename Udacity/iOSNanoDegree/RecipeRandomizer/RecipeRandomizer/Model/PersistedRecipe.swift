//
//  PersistedRecipe.swift
//  RecipeRandomizer
//
//  Created by Luis Antonio Rodriguez on 1/31/16.
//  Copyright © 2016 Luis Antonio Rodriguez. All rights reserved.
//

import Foundation
import CoreData

class PersistedRecipe : NSManagedObject{
    @NSManaged var id: String
    @NSManaged var title: String
    @NSManaged var source_url: String
    @NSManaged var image_url: String
    @NSManaged var publisher: String
    @NSManaged var ingredients: [PersistedIngredient]
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String : AnyObject], context: NSManagedObjectContext) {
        let entity =  NSEntityDescription.entityForName("Recipe", inManagedObjectContext: context)!
        super.init(entity: entity,insertIntoManagedObjectContext: context)
        id = dictionary[RecipeKeys.ID] as! String
        title = dictionary[RecipeKeys.TITLE] as! String
        source_url = dictionary[RecipeKeys.SOURCE_URL] as! String
        image_url = dictionary[RecipeKeys.IMAGE_URL] as! String
        publisher = dictionary[RecipeKeys.PUBLISHER] as! String
    }
    
    init(recipe: Recipe, context: NSManagedObjectContext) {
        let entity =  NSEntityDescription.entityForName("Recipe", inManagedObjectContext: context)!
        super.init(entity: entity,insertIntoManagedObjectContext: context)
        id = recipe.id!
        title = recipe.title!
        source_url = recipe.source_url!
        image_url = recipe.image_url!
        publisher = recipe.publisher!
    }
}