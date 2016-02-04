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
                for p in photos {
                    let d = p as! NSDictionary
                    let id = d["id"] as! String
                    let title = d["title"] as! String
                    self.getPhotoForId(id){(success, errorString, photoSizes) -> Void in
                        if(success){
                            if let photoSizes = photoSizes{
                                for size in photoSizes{
                                    let label = size["label"] as! String?
                                    if let label = label {
                                        if label == "Thumbnail" {
                                            let url = size["source"] as! String?
                                            if let url = url{
                                                print(url)
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
                                    }
                                }
                            }
                        }else{
                            //TODO: handle error here
                        }
                    };
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

    func getPhotoForId(photoId: String, completionHandler: (success: Bool, errorString: String?, photoSizes: NSArray?) -> Void) {
        let parameters = [
            "method": "flickr.photos.getSizes",
            "api_key": self.API_KEY,
            "photo_id": photoId,
            "format": self.DATA_FORMAT,
            "nojsoncallback": self.NO_JSON_CALLBACK
        ]
        
        WebServiceHelpers.sharedInstance().taskForGETMethod(BASE_URL, method: "", parameters: parameters, requestValues: [:], needsTruncating: false) { (result, error) in
            if error == nil {
                /* GUARD: Did Flickr return an error (stat != ok)? */
                if result["stat"] as? String != "ok"{
                    let errorString = "Flickr API returned an error. Error code: \(result.code)"
                    print(errorString)
                    //return an error
                    completionHandler(success: false, errorString: errorString, photoSizes: nil)
                }
//                print("result = \(result)")
                let data = result["sizes"] as! NSDictionary
                let photos = data["size"] as! NSArray
                completionHandler(success: true, errorString: nil, photoSizes: photos)
            }else {
                if error!.code == 403 || error!.code == 400{
                    completionHandler(success: false, errorString: "An error occurred while logging in, make sure that your username and password are correct", photoSizes: nil)
                }else{
                    completionHandler(success: false, errorString: "An error occurred while logging in, there seems to be a connectivity issue", photoSizes: nil)
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