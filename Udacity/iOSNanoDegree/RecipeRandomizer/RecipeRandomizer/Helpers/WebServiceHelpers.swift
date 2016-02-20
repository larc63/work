//
//  WebServiceHelpers.swift
//  RecipeRandomizer
//
//  Created by Luis Antonio Rodriguez on 11/25/15.
//  Copyright © 2015 Luis Antonio Rodriguez. All rights reserved.
//

import Foundation
class WebServiceHelpers : NSObject {
    // MARK: Properties
    
    /* Shared session */
    var session: NSURLSession
    
    /* Authentication state */
    var sessionID : String? = nil
    var userID : Int? = nil
    
    // MARK: Initializers
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    func taskForGETMethod(baseURL: String, method: String, parameters: [String : AnyObject], requestValues: [String:String], needsTruncating: Bool, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        /* 1. Build the URL and configure the request */
        let urlString = baseURL + method + WebServiceHelpers.escapedParameters(parameters)
        let url = NSURL(string: urlString)!
        print(url)
        let request = NSMutableURLRequest(URL: url)
        for (key, value) in requestValues {
            request.addValue(value, forHTTPHeaderField: key)
        }
        /* 2. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                // call completionHandler
                completionHandler(result: nil, error:error)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                var error: NSError
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                    error = NSError(domain: "HTTPError", code: response.statusCode, userInfo: nil)
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                    error = NSError(domain: "HTTPError \(response)", code: 0, userInfo: nil)
                } else {
                    print("Your request returned an invalid response!")
                    error = NSError(domain: "HTTPError invalid response", code: 0, userInfo: nil)
                }
                completionHandler(result: nil, error: error)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard var data = data else {
                print("No data was returned by the request!")
                let error = NSError(domain: "No data returned", code: 0, userInfo: nil)
                completionHandler(result: nil, error: error)
                return
            }
            if needsTruncating{
                data = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            WebServiceHelpers.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: POST
    
    func taskForPOSTMethod(baseURL: String, method: String, parameters: [String : AnyObject], jsonBody: [String:AnyObject], requestValues: [String : String], needsTruncating: Bool, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        /* 1. Build the URL and configure the request */
        let urlString = baseURL + method + WebServiceHelpers.escapedParameters(parameters)
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        for (key, value) in requestValues {
            request.addValue(value, forHTTPHeaderField: key)
        }
        do {
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
        }
        /* 2. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                // call completionHandler
                completionHandler(result: nil, error:error)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                var error: NSError
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                    error = NSError(domain: "HTTPError", code: response.statusCode, userInfo: nil)
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                    error = NSError(domain: "HTTPError \(response)", code: 0, userInfo: nil)
                } else {
                    print("Your request returned an invalid response!")
                    error = NSError(domain: "HTTPError invalid response", code: 0, userInfo: nil)
                }
                completionHandler(result: nil, error: error)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard var data = data else {
                print("No data was returned by the request!")
                let error = NSError(domain: "No data returned", code: 0, userInfo: nil)
                completionHandler(result: nil, error: error)
                return
            }
            if needsTruncating{
                data = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            }
            //print(NSString(data: data, encoding: NSUTF8StringEncoding))
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            WebServiceHelpers.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    //MARK: delete
    
    func taskForDELETEMethod(baseURL: String, method: String, parameters: [String : AnyObject], jsonBody: [String:AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        /* 1. Build the URL and configure the request */
        let urlString = baseURL + method + WebServiceHelpers.escapedParameters(parameters)
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies as [NSHTTPCookie]! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        /* 2. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                // call completionHandler
                completionHandler(result: nil, error:error)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                var error: NSError
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                    error = NSError(domain: "HTTPError", code: response.statusCode, userInfo: nil)
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                    error = NSError(domain: "HTTPError \(response)", code: 0, userInfo: nil)
                } else {
                    print("Your request returned an invalid response!")
                    error = NSError(domain: "HTTPError invalid response", code: 0, userInfo: nil)
                }
                completionHandler(result: nil, error: error)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                let error = NSError(domain: "No data returned", code: 0, userInfo: nil)
                completionHandler(result: nil, error: error)
                return
            }
            // since no other APIs except Udacity use this method, the boolean isn't necessary
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            WebServiceHelpers.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
        }
        
        /* 7. Start the request */
        task.resume()
        return task
    }
    
    func taskForImageWithUrl(fileUrl: String, completionHandler: (imageData: NSData?, error: NSError?) ->  Void) -> NSURLSessionTask {
        let baseURL = NSURL(string: fileUrl)!
        let request = NSURLRequest(URL: baseURL)
        
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            
            if let _ = downloadError {
                let newError = "error occurred"
                completionHandler(imageData: nil, error: NSError(domain: newError, code: 0, userInfo: nil))
            } else {
                completionHandler(imageData: data, error: nil)
            }
        }
        
        task.resume()
        
        return task
    }
    
    // MARK: Helpers
    
    /* Helper: Substitute the key for the value that is contained within the method name */
    class func subtituteKeyInMethod(method: String, key: String, value: String) -> String? {
        if method.rangeOfString("{\(key)}") != nil {
            return method.stringByReplacingOccurrencesOfString("{\(key)}", withString: value)
        } else {
            return nil
        }
    }
    
    /* Helper: Given raw JSON, return a usable Foundation object */
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandler(result: nil, error: NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandler(result: parsedResult, error: nil)
    }
    
    /* Helper function: Given a dictionary of parameters, convert to a string for a url */
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
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
    // MARK: Shared Instance
    
    class func sharedInstance() -> WebServiceHelpers {
        struct WebServiceHelpersSingleton {
            static var sharedInstance = WebServiceHelpers()
        }
        return WebServiceHelpersSingleton.sharedInstance
    }
}