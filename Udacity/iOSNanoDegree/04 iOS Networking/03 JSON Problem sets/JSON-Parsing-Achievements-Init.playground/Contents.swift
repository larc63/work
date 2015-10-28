//
//  JSON-Parsing-Achievements-Solution.playground
//  iOS Networking
//
//  Created by Jarrod Parkes on 09/30/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import Foundation

/* Path for JSON files bundled with the Playground */
var pathForAchievementsJSON = NSBundle.mainBundle().pathForResource("achievements", ofType: "json")

/* Raw JSON data (...simliar to the format you might receive from the network) */
var rawAchievementsJSON = NSData(contentsOfFile: pathForAchievementsJSON!)

/* Error object */
var parsingAchivementsError: NSError? = nil

/* Parse the data into usable form */
var parsedAchievementsJSON = try! NSJSONSerialization.JSONObjectWithData(rawAchievementsJSON!, options: .AllowFragments) as! NSDictionary
var counter = 0
var accumulator:Double = 0;
func parseJSONAsDictionary(dictionary: NSDictionary) {
    /* Start playing with JSON here... */
    var matchmakingCategories:[Int] = []
    var matchmakingCategoriesCount = 0
    
    let categories = dictionary["categories"] as! NSArray
    for i in 0..<categories.count{
        let category = categories[i] as! NSDictionary
        let title = category["title"] as! String
        if title == "Matchmaking"{
            let children = category["children"] as! NSArray
            for child in children{
                matchmakingCategories.append(child["categoryId"] as! Int)
            }
        }
    }
    let achievments = dictionary["achievements"] as! NSArray
    //    let i = 2
    for i in 0..<achievments.count{
        let achievment = achievments[i] as! NSDictionary
        _ = achievment["title"] as! String
        _ = achievment["description"] as! String
        _ = achievment["achievementId"] as! Int
        let categoryId = achievment["categoryId"] as! Int
        let points = achievment["points"] as! Int
        if points > 10{
            counter++
        }
        accumulator += Double(points)
        if matchmakingCategories.contains(categoryId){
            matchmakingCategoriesCount += 1
        }
        
        let icon = achievment["icon"] as! NSDictionary
        _ = icon["x"] as! Int
        _ = icon["y"] as! Int
        _ = icon["w"] as! Int
        _ = icon["h"] as! Int
        _ = icon["offset"] as! Int
        _ = icon["url"]
    }
    counter
    accumulator /= Double(achievments.count)
}

parseJSONAsDictionary(parsedAchievementsJSON)





