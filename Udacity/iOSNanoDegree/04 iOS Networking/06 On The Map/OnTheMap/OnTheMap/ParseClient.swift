//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Luis Antonio Rodriguez on 12/2/15.
//  Copyright © 2015 Luis Antonio Rodriguez. All rights reserved.
//

import Foundation
class  ParseClient {
    let applicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    let APIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MediaUrl = "mediaURL"
    }
    
    func getUserLocations(completionHandler: (success: Bool, errorString: String?, userLocations: NSArray) -> Void ){
        print("getting user locations")
        WebServiceHelpers.sharedInstance().taskForGETMethod("https://api.parse.com/1/classes/", method: "StudentLocation", parameters: ["limit":"100", "order":"-updatedAt"], requestValues: ["X-Parse-Application-Id" : applicationID, "X-Parse-REST-API-Key" : APIKey], needsTruncating: false) {(result, errorString) in
//            print("result = \(result)")
            let values = result["results"] as! NSArray
            print("got \(values.count) entries")
            completionHandler(success: true, errorString: nil, userLocations: values)
        }
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> ParseClient {
        
        struct ParseSingleton {
            static var sharedInstance = ParseClient()
        }
        
        return ParseSingleton.sharedInstance
    }
    
}