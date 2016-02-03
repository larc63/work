//
//  PinManager.swift
//  VirtualTourist
//
//  Created by Luis Antonio Rodriguez on 2/3/16.
//  Copyright © 2016 Luis Antonio Rodriguez. All rights reserved.
//

import Foundation
import CoreData

class PinManager {
    
    class var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    class func fetchAllPins() -> [Pin] {
        // Create the Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "Pin")
        // Execute the Fetch Request
        do {
            return try sharedContext.executeFetchRequest(fetchRequest) as! [Pin]
        } catch  let error as NSError {
            print("Error in fetchAllPins(): \(error)")
            return [Pin]()
        }
    }
    
    class func findPinFromLatitude(latitude: Double, andLongitude longitude: Double) -> [Pin]{
        let predicate = NSPredicate(format: "latitude == %lf AND longitude == %lf", latitude, longitude)
        let fetchRequest = NSFetchRequest(entityName: "Pin")
        fetchRequest.predicate = predicate
        do {
            return try sharedContext.executeFetchRequest(fetchRequest) as! [Pin]
        } catch  let error as NSError {
            print("Error in fetchAllPins(): \(error)")
            return [Pin]()
        }
    }

    
}