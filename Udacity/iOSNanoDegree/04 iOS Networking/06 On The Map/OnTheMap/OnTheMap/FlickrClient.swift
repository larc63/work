//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Luis Antonio Rodriguez on 11/25/15.
//  Copyright © 2015 Luis Antonio Rodriguez. All rights reserved.
//

import Foundation

class  FlickrClient {
    let BASE_URL = "https://api.flickr.com/services/rest/"
    let METHOD_NAME = "flickr.photos.search"
    let API_KEY = "28388cd732250dfd1cfbd8168b077536"
    let EXTRAS = "url_m"
    let DATA_FORMAT = "json"
    let NO_JSON_CALLBACK = "1"

    
    // MARK: Authentication (POST) Method
    func getPhotoSetForLocation(hostViewController: ViewController, long: String, lat: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        let parameters = [
            "method": METHOD_NAME,
            "api_key": API_KEY,
            "lon": long,
            "lat": lat,
            "format": DATA_FORMAT,
            "nojsoncallback": NO_JSON_CALLBACK
        ]
        WebServiceHelpers.sharedInstance().taskForGETMethod(BASE_URL, method: "", parameters: parameters, requestValues: [:], needsTruncating: false) { (result, error) in
            if error == nil {
                /* GUARD: Did Flickr return an error (stat != ok)? */
                guard let stat = parsedResult["stat"] as? String where stat == "ok" else {
                    print("Flickr API returned an error. Error code: \(parsedResult.code)")
                    return
                }
                print("result = \(result)")
                let photos = result["photo"] as! NSDictionary
//                let account = result["account"] as! NSDictionary
//                let registered = account["registered"] as! Bool
//                self.userId = account["key"] as! String?
//                if registered {
//                    self.getUserData(){ (success, errorString) in
//                        if (success){
//                            completionHandler(success: true, errorString: nil)
//                        } else {
//                            completionHandler(success: false, errorString: errorString)
//                        }
//                    }
//                }else{
//                    completionHandler(success: false, errorString: "An error occurred while logging in, make sure that your username and password are correct")
//                }
            }else {
//                if error!.code == 403 || error!.code == 400{
//                    completionHandler(success: false, errorString: "An error occurred while logging in, make sure that your username and password are correct")
//                }else{
//                    completionHandler(success: false, errorString: "An error occurred while logging in, there seems to be a connectivity issue")
//                }
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