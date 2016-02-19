//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Luis Antonio Rodriguez on 11/25/15.
//  Copyright © 2015 Luis Antonio Rodriguez. All rights reserved.
//

import Foundation
import CoreData

class  Food2Fork {
    let BASE_URL = "http://food2fork.com/api/"
    let SEARCH_METHOD_NAME = "search"
    let API_KEY = "de2c50d89e3ad1435484f580d88e4efa"
    let GET_METHOD_NAME = "get"
    
    
    func getPhotoSetForLocation(searchTerms: Array<String>, completionHandler: (success: Bool, errorString: String?, recipeData: NSArray?) -> Void) {
        let parameters = [
            "api_key": API_KEY,
            "q": searchTerms.joinWithSeparator(",")
        ]
        WebServiceHelpers.sharedInstance().taskForGETMethod(BASE_URL, method: SEARCH_METHOD_NAME, parameters: parameters, requestValues: [:], needsTruncating: false) { (result, error) in
            if error == nil {
                /* GUARD: Did Flickr return an error (stat != ok)? */
//                if result["stat"] as? String != "ok"{
//                    let errorString = "Flickr API returned an error. Error code: \(result.code)"
//                    print(errorString)
//                    //return an error
//                    completionHandler(success: false, errorString: errorString, photoData: nil)
//                }
////                print("result = \(result)")
//                let data = result["photos"] as! NSDictionary
//                let photos = data["photo"] as! NSArray
//                let m:UInt32 = ((photos.count > 60) ? 30 as UInt32: 100 as UInt32)
//                print("getting \(m) photos for set")
//                for p in photos {
//                    if arc4random_uniform(100) < m {
//                        let d = p as! NSDictionary
//                        let id = d["id"] as! String
//                        let title = d["title"] as! String
//                        let url = d["url_m"] as! String
//                        //                    print("Photo with title: \(title) has url=\(url)")
//                        let dictionary: [String : AnyObject] = [
//                            Photo.Keys.Id : id,
//                            Photo.Keys.Title : title,
//                            Photo.Keys.ThumbnailURL : url
//                        ]
//                    }
//                }
//                completionHandler(success: true, errorString: nil, photoData: photos)
//            }else {
//                if error!.code == 403 || error!.code == 400{
//                    completionHandler(success: false, errorString: "An error occurred while logging in, make sure that your username and password are correct", photoData: nil)
//                }else{
//                    completionHandler(success: false, errorString: "An error occurred while logging in, there seems to be a connectivity issue", photoData: nil)
//                }
            }
        }
    }
    
    // MARK: Shared Instance
    class func sharedInstance() -> Food2Fork {
        struct Singleton {
            static var sharedInstance = Food2Fork()
        }
        return Singleton.sharedInstance
    }
}