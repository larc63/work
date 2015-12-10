//
//  EnterURLTest.swift
//  OnTheMap
//
//  Created by Luis Antonio Rodriguez on 12/10/15.
//  Copyright © 2015 Luis Antonio Rodriguez. All rights reserved.
//

import XCTest

class EnterURLTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssert(Helpers.isValidURL("") == false)
        XCTAssert(Helpers.isValidURL("http") == false)
        XCTAssert(Helpers.isValidURL("https") == false)
        XCTAssert(Helpers.isValidURL("http://") == false)
        XCTAssert(Helpers.isValidURL("asdf://") == false)
        XCTAssert(Helpers.isValidURL("https://") == false)
        XCTAssert(Helpers.isValidURL("https://www") == false)
        XCTAssert(Helpers.isValidURL("https://www.") == false)
        XCTAssert(Helpers.isValidURL("http://w.w.w") == true)
        XCTAssert(Helpers.isValidURL("http://w.w.w/") == true)
        XCTAssert(Helpers.isValidURL("https://w.w.w") == true)
        XCTAssert(Helpers.isValidURL("https://w.w.w/") == true)
        XCTAssert(Helpers.isValidURL("w.w.w") == true)
        XCTAssert(Helpers.isValidURL("w.w.w/") == true)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
