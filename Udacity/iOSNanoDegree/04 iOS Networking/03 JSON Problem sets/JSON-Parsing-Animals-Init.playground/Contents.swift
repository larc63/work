//
//  JSON-Parsing-Animals-Solution.playground
//  iOS Networking
//
//  Created by Jarrod Parkes on 09/30/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import Foundation

/* Path for JSON files bundled with the Playground */
var pathForAnimalsJSON = NSBundle.mainBundle().pathForResource("animals", ofType: "json")

/* Raw JSON data (...simliar to the format you might receive from the network) */
var rawAnimalsJSON = NSData(contentsOfFile: pathForAnimalsJSON!)

/* Error object */
var parsingAnimalsError: NSError? = nil

/* Parse the data into usable form */
var parsedAnimalsJSON = try! NSJSONSerialization.JSONObjectWithData(rawAnimalsJSON!, options: .AllowFragments) as! NSDictionary

func parseJSONAsDictionary(dictionary: NSDictionary) {
    /* Start playing with JSON here... */
    let photos = dictionary["photos"] as! NSDictionary
    let photo = photos["photo"] as! NSArray
    photo.count
    for i in 0..<photo.count {
        let p = photo[i] as! NSDictionary
        let comment = p["comment"] as! NSDictionary
        let content = comment["_content"] as! String
        if content.rangeOfString("interrufftion") != nil{
            _ = photo[i]["id"] as! String
            content
        }
        if i == 2 {
            _ = photo[i]["id"] as! String
            content
        }
        
    }
}

parseJSONAsDictionary(parsedAnimalsJSON)
