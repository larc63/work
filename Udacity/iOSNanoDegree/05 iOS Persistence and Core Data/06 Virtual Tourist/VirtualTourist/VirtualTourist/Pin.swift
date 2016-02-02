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
    @NSManaged var longitude: Double
    @NSManaged var latitude: Double
    @NSManaged var photos: [Photo]
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String : AnyObject], context: NSManagedObjectContext) {
        let entity =  NSEntityDescription.entityForName("Pin", inManagedObjectContext: context)!
        super.init(entity: entity,insertIntoManagedObjectContext: context)
        longitude = dictionary[Keys.Longitude] as! Double
        latitude = dictionary[Keys.Latitude] as! Double
    }
}