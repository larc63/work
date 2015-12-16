//
//  OnTheMapUITests.swift
//  OnTheMapUITests
//
//  Created by Luis Antonio Rodriguez on 11/25/15.
//  Copyright © 2015 Luis Antonio Rodriguez. All rights reserved.
//

import XCTest

class OnTheMapUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        
        let app = XCUIApplication()
        let usernameTextField = app.textFields["Username"]
        usernameTextField.tap()
        usernameTextField.typeText("larc63@gmail.com")
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        UIPasteboard.generalPasteboard().string = "vacaloca"
        passwordSecureTextField.doubleTap()
        app.menuItems["Paste"].tap()
        app.buttons["Login"].tap()
        
        let onthemapMainviewNavigationBar = app.navigationBars["OnTheMap.Mainview"]
        let buttons = NSPredicate(format: "count == 4")
        expectationForPredicate(buttons, evaluatedWithObject: onthemapMainviewNavigationBar.buttons, handler: nil)
        waitForExpectationsWithTimeout(5, handler: nil)
        onthemapMainviewNavigationBar.buttons["MapMarker"].tap()
        
//        let element = app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element
////        let geoButton = NSPredicate(format: "count == 1")
////        expectationForPredicate(geoButton, evaluatedWithObject: element.buttons, handler: nil)
////        waitForExpectationsWithTimeout(5, handler: nil)
//        NSThread.sleepForTimeInterval(5)
//        let textView = element.childrenMatchingType(.TextView).elementBoundByIndex(1)
//        textView.tap()
//        textView.typeText("Ensenada, Mexico")
//        app.buttons["Find On Map"].tap()
//        
//        let textView2 = element.childrenMatchingType(.TextView).element
//        textView2.tap()
//        textView2.typeText("www.lavacahacemu.com")
//        app.buttons["Submit"].tap()
//        onthemapMainviewNavigationBar.buttons["Log Out"].tap()
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}
