//
//  ViewController.swift
//  Flick Finder
//
//  Created by Luis Antonio Rodriguez on 10/10/15.
//  Copyright © 2015 Luis Antonio Rodriguez. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var searchByPhraseButton: UIButton!
    @IBOutlet weak var searchByPhraseTextField: UITextField!
    @IBOutlet weak var searchByCoordinatesButton: UIButton!
    @IBOutlet weak var latitudeText: UITextField!
    @IBOutlet weak var longitudeText: UITextField!
    @IBOutlet weak var photoTitle: UILabel!
    
    /* 1 - Define constants */
    let BASE_URL = "https://api.flickr.com/services/rest/"
    let METHOD_NAME = "flickr.photos.search"
    let API_KEY = "28388cd732250dfd1cfbd8168b077536"
    let EXTRAS = "url_m"
    let DATA_FORMAT = "json"
    let NO_JSON_CALLBACK = "1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchByPhraseTextField.delegate = self;
        latitudeText.delegate = self;
        longitudeText.delegate = self;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* Helper function: Given a dictionary of parameters, convert to a string for a url */
    func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
    
    func doSearch(){
        
        searchByPhraseTextField.text = ""
        //        searchByPhraseTextField.text = "cat"
        latitudeText.text = "32.9210919"
        longitudeText.text = "-96.7502917"
        let searchString = searchByPhraseTextField.text!
        let latitude = latitudeText.text!
        let longitude = longitudeText.text!
        
        /* 2 - API method arguments */
        var methodArguments = [
            "method": METHOD_NAME,
            "api_key": API_KEY,
            "text": searchString,
            "lon": longitude,
            "lat": latitude,
            //                "extras": EXTRAS,
            "format": DATA_FORMAT,
            "nojsoncallback": NO_JSON_CALLBACK
        ]
        
        /* 3 - Initialize session and url */
        let session = NSURLSession.sharedSession()
        let urlString = BASE_URL + escapedParameters(methodArguments)
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        
        /* 4 - Initialize task for getting data */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                return
            }
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            /* 6 - Parse the data (i.e. convert the data to JSON and look for values!) */
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                parsedResult = nil
                print("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            /* GUARD: Did Flickr return an error (stat != ok)? */
            guard let stat = parsedResult["stat"] as? String where stat == "ok" else {
                print("Flickr API returned an error. Error code: \(parsedResult.code)")
                return
            }
            
            /* GUARD: Are the "photos" and "photo" keys in our result? */
            guard let photosDictionary = parsedResult["photos"] as? NSDictionary,
                let photoArray = photosDictionary["photo"] as? [[String: AnyObject]] else {
                    print("Cannot find keys 'photos' and 'photo' in \(parsedResult)")
                    return
            }
            
            /* 7 - Generate a random number, then select a random photo */
            let randomPhotoIndex = Int(arc4random_uniform(UInt32(photoArray.count)))
            let photoDictionary = photoArray[randomPhotoIndex] as [String: AnyObject]
            guard let photoTitle = photoDictionary["title"] as? String else{
                print("Could not get the title for the photo")
                return
            }
            if let photoID = photoDictionary["id"] as? String {
                /* 2 - API method arguments */
                methodArguments = [
                    "method": "flickr.photos.getSizes",
                    "api_key": self.API_KEY,
                    "photo_id": photoID,
                    "format": self.DATA_FORMAT,
                    "nojsoncallback": self.NO_JSON_CALLBACK
                ]
                
                /* 3 - Initialize session and url */
                let session = NSURLSession.sharedSession()
                let urlString = self.BASE_URL + self.escapedParameters(methodArguments)
                let url = NSURL(string: urlString)!
                let request = NSURLRequest(URL: url)
                let task = session.dataTaskWithRequest(request) { (data, response, error) in
                    /* GUARD: Was there an error? */
                    guard (error == nil) else {
                        print("There was an error with your request: \(error)")
                        return
                    }
                    /* GUARD: Did we get a successful 2XX response? */
                    guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                        if let response = response as? NSHTTPURLResponse {
                            print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                        } else if let response = response {
                            print("Your request returned an invalid response! Response: \(response)!")
                        } else {
                            print("Your request returned an invalid response!")
                        }
                        return
                    }
                    
                    /* GUARD: Was there any data returned? */
                    guard let data = data else {
                        print("No data was returned by the request!")
                        return
                    }
                    
                    /* 6 - Parse the data (i.e. convert the data to JSON and look for values!) */
                    let parsedResult: AnyObject!
                    do {
                        parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                    } catch {
                        parsedResult = nil
                        print("Could not parse the data as JSON: '\(data)'")
                        return
                    }
                    
                    /* GUARD: Did Flickr return an error (stat != ok)? */
                    guard let stat = parsedResult["stat"] as? String where stat == "ok" else {
                        print("Flickr API returned an error. Error code: \(parsedResult.code)")
                        return
                    }
                    
                    /* GUARD: Are the "photos" and "photo" keys in our result? */
                    guard let sizesDictionary = parsedResult["sizes"] as? NSDictionary,
                        let sizesArray = sizesDictionary["size"] as? [[String: AnyObject]] else {
                            print("Cannot find keys 'sizes' and 'size' in \(parsedResult)")
                            return
                    }
                    var indexToUse = sizesArray.count - 1
                    for i in 0..<sizesArray.count {
                        let sd = sizesArray[i]
                        var width:CGFloat?
                        if let widthString = sd["width"] as? String {
                            width = CGFloat(Float(widthString)!)
                            print("with for \(i) is \(width) as a String")
                        }else if let cgwidth = sd["width"] as? CGFloat{
                            width = cgwidth
                            print("with for \(i) is \(width) as a CGFloat")
                            
                        }
                        if let width = width{
                            if width > self.imageView.frame.width{
                                indexToUse = i
                                break
                            }
                        }
                    }
                    
                    let photoDictionary = sizesArray[indexToUse] as [String: AnyObject]
                    if let photoURL = photoDictionary["source"] as? String /* non-fatal */{
                        /* 8 - If an image exists at the url, set the image and title */
                        let imageURL = NSURL(string: photoURL)
                        if let imageData = NSData(contentsOfURL: imageURL!) {
                            dispatch_async(dispatch_get_main_queue(), {
                                self.imageView.image = UIImage(data: imageData)
                                self.photoTitle.text = photoTitle
                            })
                        } else {
                            print("Image does not exist at \(imageURL)")
                        }
                    }
                    
                }
                task.resume()
            }
            
        }
        
        /* 9 - Resume (execute) the task */
        task.resume()
    }
    

    @IBAction func searchByPhrase(sender: AnyObject) {
        doSearch()
    }

    @IBAction func searchByCoordinates(sender: AnyObject) {
        doSearch()
    }
}

