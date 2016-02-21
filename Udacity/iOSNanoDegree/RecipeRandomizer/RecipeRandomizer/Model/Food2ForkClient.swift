//
//  Food2ForkClient.swift
//  RecipeRandomizer
//
//  Created by Luis Antonio Rodriguez on 11/25/15.
//  Copyright © 2015 Luis Antonio Rodriguez. All rights reserved.
//

import Foundation
import CoreData

class  Food2ForkClient {
    let BASE_URL = "http://food2fork.com/api/"
    let SEARCH_METHOD_NAME = "search"
    let API_KEY = "de2c50d89e3ad1435484f580d88e4efa"
    let GET_METHOD_NAME = "get"
    
    func getRecipeForId(id: String, completionHandler: (success: Bool, errorString: String?, recipeData: NSDictionary?) -> Void){
        let parameters = [
            "key": API_KEY,
            "rId": id
        ]
        WebServiceHelpers.sharedInstance().taskForGETMethod(BASE_URL, method: GET_METHOD_NAME, parameters: parameters, requestValues: [:], needsTruncating: false) { (result, error) in
            if error == nil {
                let recipe = result["recipe"] as! NSDictionary
                completionHandler(success: true, errorString: nil, recipeData: recipe)
            }else {
                if error!.code == 403 || error!.code == 400{
                    completionHandler(success: false, errorString: "An error occurred while logging in, make sure that your username and password are correct", recipeData: nil)
                }else{
                    completionHandler(success: false, errorString: "An error occurred while logging in, there seems to be a connectivity issue", recipeData: nil)
                }
            }
        }
    }
    
    func getRecipesForSearchTerms(searchTerms: [String], completionHandler: (success: Bool, errorString: String?, recipeData: NSArray?) -> Void) {
        let parameters = [
            "key": API_KEY,
            "q": searchTerms.joinWithSeparator(",")
        ]
        WebServiceHelpers.sharedInstance().taskForGETMethod(BASE_URL, method: SEARCH_METHOD_NAME, parameters: parameters, requestValues: [:], needsTruncating: false) { (result, error) in
            if error == nil {
                let recipes = result["recipes"] as! NSArray
                completionHandler(success: true, errorString: nil, recipeData: recipes)
            }else {
                if error!.code == 403 || error!.code == 400{
                    completionHandler(success: false, errorString: "An error occurred while logging in, make sure that your username and password are correct", recipeData: nil)
                }else{
                    completionHandler(success: false, errorString: "An error occurred while logging in, there seems to be a connectivity issue", recipeData: nil)
                }
            }
        }
    }
    
    // MARK: Shared Instance
    class func sharedInstance() -> Food2ForkClient {
        struct Singleton {
            static var sharedInstance = Food2ForkClient()
        }
        return Singleton.sharedInstance
    }
}