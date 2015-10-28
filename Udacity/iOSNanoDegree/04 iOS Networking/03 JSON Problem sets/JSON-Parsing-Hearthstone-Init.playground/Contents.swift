//
//  JSON-Parsing-Hearthstone-Solution.playground
//  iOS Networking
//
//  Created by Jarrod Parkes on 09/30/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import Foundation

/* Path for JSON files bundled with the Playground */
var pathForHearthstoneJSON = NSBundle.mainBundle().pathForResource("hearthstone_basic_set", ofType: "json")

/* Raw JSON data (...simliar to the format you might receive from the network) */
var rawHearthstoneJSON = NSData(contentsOfFile: pathForHearthstoneJSON!)

/* Error object */
var parsingHearthstoneError: NSError? = nil

/* Parse the data into usable form */
var parsedHearthstoneJSON = try! NSJSONSerialization.JSONObjectWithData(rawHearthstoneJSON!, options: .AllowFragments) as! NSDictionary

func parseJSONAsDictionary(dictionary: NSDictionary) {
    /* Start playing with JSON here... */
    var minionsThatCost5 = 0
    var weaponsThatCost2 = 0
    var minionsWithBattlecryEffect = 0
    var numberOfcommonMinions = 0
    var accumulatedCostOfCommonMinions = 0
    var accumulatedAttackPlusHealth:Double = 0.0
    var numberOfMinions = 0
    
    let basic = dictionary["Basic"] as! NSArray
    basic.count
    for i in 0..<basic.count{
        let minion = basic[i] as! NSDictionary
        let type = minion["type"] as! String
        if type == "Minion"{
            let cost = minion["cost"] as! Int
            if cost == 5 {
                minionsThatCost5 += 1
            }
            let rarity  = minion["rarity"] as! String
            if rarity == "Common"{
                numberOfcommonMinions += 1
                accumulatedCostOfCommonMinions += cost
            }
            let text = minion["text"] as? String
            if let text = text{
                if text.rangeOfString("Battlecry") != nil{
                    minionsWithBattlecryEffect += 1
                }
            }
            if cost != 0{
                let health = minion["health"] as! Int
                let attack = minion["attack"] as! Int
                accumulatedAttackPlusHealth += Double(health + attack)/Double(cost)
                numberOfMinions += 1
            }
        }
        if type == "Weapon"{
            let durability = minion["durability"] as! Int
            if durability == 2 {
                weaponsThatCost2 += 1
            }
        }
    }
    weaponsThatCost2
    minionsWithBattlecryEffect
    Double(accumulatedCostOfCommonMinions)/Double(numberOfcommonMinions)
    Double(accumulatedAttackPlusHealth)/Double(numberOfMinions)
}

parseJSONAsDictionary(parsedHearthstoneJSON)
