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
    
    func testLoginHappyPath() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        let usernameTextField = app.textFields["Username"]
        usernameTextField.tap()
        usernameTextField.typeText("larc63@gmail.com")
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        UIPasteboard.generalPasteboard().string = "vacaloca"
        passwordSecureTextField.tap()
        passwordSecureTextField.doubleTap()
        app.menuItems["Paste"].tap()
        app.buttons["Login"].tap()
        XCTAssertEqual(app.alerts.count, 0, "An alert was shown")
    }
    
    func testLoginNoUserNoPass() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let app = XCUIApplication()
        let alertString:String = "An error occurred while logging in, make sure that your username and password are correct"
        app.buttons["Login"].tap()
        
        let alert = app.alerts["Error"].collectionViews.buttons["ok"]
        print("\(alert.staticTexts[alertString])")
        //        print(alertString)
        XCTAssertEqual(app.alerts.count, 1, "An alert was not shown")
        XCTAssertEqual(alert.staticTexts[alertString], alertString, "alert doesn't show the correct string")
        alert.tap()

    }
    
}
