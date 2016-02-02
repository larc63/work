//
//  Pin.swift
//  VirtualTourist
//
//  Created by Luis Antonio Rodriguez on 1/31/16.
//  Copyright © 2016 Luis Antonio Rodriguez. All rights reserved.
//

import Foundation
import CoreData

class Pin : NSManagedObject{
    struct Keys {
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let Photos = "photos"
    }
    @NSManaged var longitude: NSNumber
    @NSManaged var latitude: NSNumber
    
    //TODO: add photos relationship
    //@NSManaged var movies: [Movies]
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String : AnyObject], context: NSManagedObjectContext) {
        let entity =  NSEntityDescription.entityForName("Pin", inManagedObjectContext: context)!
        super.init(entity: entity,insertIntoManagedObjectContext: context)
        longitude = dictionary[Keys.Longitude] as! NSNumber
        latitude = dictionary[Keys.Latitude] as! NSNumber
    }
}