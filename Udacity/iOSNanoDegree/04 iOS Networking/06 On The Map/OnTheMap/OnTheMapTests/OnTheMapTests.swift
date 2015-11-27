//
//  OnTheMapTests.swift
//  OnTheMapTests
//
//  Created by Luis Antonio Rodriguez on 11/25/15.
//  Copyright © 2015 Luis Antonio Rodriguez. All rights reserved.
//

import XCTest
import Foundation
import UIKit

@testable import OnTheMap

class NSURLSessionDataTaskMock : NSURLSessionDataTask {
    var jsonBody:String?
    var url:String?
    var method:String?
    var body:[String:AnyObject?] = [:]
}

class NSURLSessionMock : NSURLSession {
    override func dataTaskWithRequest(request: NSURLRequest, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTaskMock{
        let retVal = NSURLSessionDataTaskMock()
        // put req and other setup into verifiable members of NSURLSessionDataTaskMock to assert their correctness
        retVal.jsonBody = try! NSJSONSerialization.JSONObjectWithData(request.HTTPBody!, options: .AllowFragments) as! String
        return retVal
    }
}

class OnTheMapTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTaskForPOSTMethod() {
        //taskForPOSTMethod(baseURL: String, method: String, parameters: [String : AnyObject], jsonBody: [String:AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        //        request.HTTPMethod = "POST"
        //        request.addValue("application/json", forHTTPHeaderField: "Accept")
        //        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //        do {
        //            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
        //        }
        let r = WebServiceHelpers.sharedInstance().taskForPOSTMethod("http://www.udacity.com/", method: "session", parameters: [:], jsonBody: ["object" : 0]) { (result, errosString) in
            /// TODO: call the completionHandler
        }
        let retVal = r as! NSURLSessionDataTaskMock
        XCTAssertTrue(retVal.url == "http://www.udacity.com/session")
        
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
