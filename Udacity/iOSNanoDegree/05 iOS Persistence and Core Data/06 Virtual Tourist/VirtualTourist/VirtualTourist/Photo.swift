//
//  Photo.swift
//  VirtualTourist
//
//  Created by Luis Antonio Rodriguez on 1/31/16.
//  Copyright © 2016 Luis Antonio Rodriguez. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Photo : NSManagedObject{
    struct Keys {
        static let Id = "id"
        static let Title = "title"
        static let ThumbnailURL = "thumbnailUrl"
    }
    @NSManaged var title : String
    @NSManaged var id : String
    @NSManaged var thumbnailUrl : String
    @NSManaged var pin : Pin?
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String : AnyObject], context: NSManagedObjectContext) {
        let entity =  NSEntityDescription.entityForName("Photo", inManagedObjectContext: context)!
        super.init(entity: entity,insertIntoManagedObjectContext: context)
        id = dictionary[Photo.Keys.Id] as! String
        thumbnailUrl = dictionary[Photo.Keys.ThumbnailURL] as! String
        title = dictionary[Photo.Keys.Title] as! String
    }
    
    var image: UIImage? {
        get {
            return ImageCache.sharedInstance().imageWithIdentifier(id)
        }
        set {
            ImageCache.sharedInstance().storeImage(newValue, withIdentifier: id)
        }
    }
}