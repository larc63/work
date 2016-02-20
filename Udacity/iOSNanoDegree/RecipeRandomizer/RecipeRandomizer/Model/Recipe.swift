//
//  Recipe.swift
//  RecipeRandomizer
//
//  Created by Luis Antonio Rodriguez on 2/19/16.
//  Copyright © 2016 Luis Antonio Rodriguez. All rights reserved.
//

import Foundation

class Recipe {
    var id: String?
    var title: String?
    var source_url: String?
    var image_url: String?
    var publisher: String?
    
    
    init(dictionary: [String : AnyObject]) {
        id = dictionary[RecipeKeys.ID] as! String?
        title = dictionary[RecipeKeys.TITLE] as! String?
        source_url = dictionary[RecipeKeys.SOURCE_URL] as! String?
        image_url = dictionary[RecipeKeys.IMAGE_URL] as! String?
        publisher = dictionary[RecipeKeys.PUBLISHER] as! String?
    }
}