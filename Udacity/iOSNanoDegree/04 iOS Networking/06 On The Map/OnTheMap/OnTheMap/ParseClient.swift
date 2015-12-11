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
            //TODO: add an if for the errorString!!!
            let values = result["results"] as! NSArray
            print("got \(values.count) entries")
            print("got \(values)")
            completionHandler(success: true, errorString: nil, userLocations: values)
        }
    }
    
    
    
    func postUserLocation(uniqueKey: String, firstName: String, lastName: String, placeName: String, mediaURL: String, latitude: Double, longitude: Double, completionHandler: (success: Bool, errorString: String?) -> Void ){
        print("sending user locations")
        let jsonBody:[String : AnyObject] = ["uniqueKey" : uniqueKey,
            "firstName" : firstName,
            "lastName"  : lastName,
            "mapString" : placeName,
            "mediaURL"  : mediaURL,
            "latitude" : latitude,
            "longitude" : longitude]
        
        WebServiceHelpers.sharedInstance().taskForPOSTMethod("https://api.parse.com/1/classes/", method: "StudentLocation", parameters: [:], jsonBody: jsonBody, requestValues: ["X-Parse-Application-Id" : applicationID, "X-Parse-REST-API-Key" : APIKey], needsTruncating: false){ (result, error) in
            let success = result["objectId"] as! String?
            if error != nil && success == nil {
                completionHandler(success: false, errorString: "An error occured while posting your location")
            }else{
                completionHandler(success: true, errorString: nil)
            }
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