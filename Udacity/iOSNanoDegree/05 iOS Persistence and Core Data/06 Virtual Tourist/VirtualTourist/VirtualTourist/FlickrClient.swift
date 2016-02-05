//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Luis Antonio Rodriguez on 11/25/15.
//  Copyright © 2015 Luis Antonio Rodriguez. All rights reserved.
//

import Foundation
import CoreData

class  FlickrClient {
    let BASE_URL = "https://api.flickr.com/services/rest/"
    let METHOD_NAME = "flickr.photos.search"
    let API_KEY = "28388cd732250dfd1cfbd8168b077536"
    let EXTRAS = "url_m"
    let DATA_FORMAT = "json"
    let NO_JSON_CALLBACK = "1"
    
    func getPhotoSetForLocation(pin: Pin, context: NSManagedObjectContext, completionHandler: (success: Bool, errorString: String?, photoData: NSArray?) -> Void) {
        let parameters = [
            "method": METHOD_NAME,
            "api_key": API_KEY,
            "lon": "\(pin.longitude)",
            "lat": "\(pin.latitude)",
            "format": DATA_FORMAT,
            "extras": "url_m",
            "per_page": "500",
            "nojsoncallback": NO_JSON_CALLBACK
        ]
        WebServiceHelpers.sharedInstance().taskForGETMethod(BASE_URL, method: "", parameters: parameters, requestValues: [:], needsTruncating: false) { (result, error) in
            if error == nil {
                /* GUARD: Did Flickr return an error (stat != ok)? */
                if result["stat"] as? String != "ok"{
                    let errorString = "Flickr API returned an error. Error code: \(result.code)"
                    print(errorString)
                    //return an error
                    completionHandler(success: false, errorString: errorString, photoData: nil)
                }
//                print("result = \(result)")
                let data = result["photos"] as! NSDictionary
                let photos = data["photo"] as! NSArray
                let m:UInt32 = ((photos.count > 60) ? 30 as UInt32: 100 as UInt32)
                print("getting \(m) photos for set")
                for p in photos {
                    if arc4random_uniform(100) < m {
                        let d = p as! NSDictionary
                        let id = d["id"] as! String
                        let title = d["title"] as! String
                        let url = d["url_m"] as! String
                        //                    print("Photo with title: \(title) has url=\(url)")
                        let dictionary: [String : AnyObject] = [
                            Photo.Keys.Id : id,
                            Photo.Keys.Title : title,
                            Photo.Keys.ThumbnailURL : url
                        ]
                        context.performBlockAndWait(){
                            let photo = Photo(dictionary: dictionary, context: context)
                            photo.pin = pin
                        }
                    }
                }
                completionHandler(success: true, errorString: nil, photoData: photos)
            }else {
                if error!.code == 403 || error!.code == 400{
                    completionHandler(success: false, errorString: "An error occurred while logging in, make sure that your username and password are correct", photoData: nil)
                }else{
                    completionHandler(success: false, errorString: "An error occurred while logging in, there seems to be a connectivity issue", photoData: nil)
                }
            }
        }
    }
        
    // MARK: Shared Instance
    
    class func sharedInstance() -> FlickrClient {
        struct Singleton {
            static var sharedInstance = FlickrClient()
        }
        return Singleton.sharedInstance
    }
}