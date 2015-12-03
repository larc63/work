//
//  UdacityStudent.swift
//  OnTheMap
//
//  Created by Luis Antonio Rodriguez on 12/2/15.
//  Copyright © 2015 Luis Antonio Rodriguez. All rights reserved.
//

import Foundation


struct UdacityStudent {
    
    // MARK: Properties
    
    var name = ""
    var lat:Double = 0
    var lon:Double = 0
    var mediaURL = ""
    
    // MARK: Initializers
    
    /* Construct a TMDBMovie from a dictionary */
    init(dictionary: [String : AnyObject]) {
        
        name = (dictionary[ParseClient.JSONResponseKeys.FirstName] as! String) + " " + (dictionary[ParseClient.JSONResponseKeys.LastName] as! String)
        lat = dictionary[ParseClient.JSONResponseKeys.Latitude] as! Double
        lon = dictionary[ParseClient.JSONResponseKeys.Longitude] as! Double
        mediaURL = dictionary[ParseClient.JSONResponseKeys.MediaUrl] as! String
    }
    /* Helper: Given an array of dictionaries, convert them to an array of TMDBMovie objects */
    static func studentsFromResults(results: [[String : AnyObject]]) -> [UdacityStudent] {
        var students = [UdacityStudent]()
        
        for result in results {
            students.append(UdacityStudent(dictionary: result))
        }
        
        return students
    }
}