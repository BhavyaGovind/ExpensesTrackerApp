//
//  ExpensesTrackerAppUITests.swift
//  ExpensesTrackerAppUITests
//
//  Created by Santosh Govind on 3/6/25.
//

import XCTest

final class SignInUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUp(){
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDown() {
        app = nil
        super.tearDown()
    }
    
    func testSignInButtonExists() {
        let signInButton = app.buttons["signInButton"]
        XCTAssertTrue(signInButton.exists, "Sign-in button should be visible")
    }
    
    func testSignInButtonTapOpenGoogleSignInFlow() {
        let signInButton = app.buttons["signInButton"]
        XCTAssertTrue(signInButton.exists, "Sign-in button should be visible")
        
        signInButton.tap()
        
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
            let continueButton = springboard.buttons["Continue"] // Change this based on actual button text
            
            if continueButton.waitForExistence(timeout: 3) {
                continueButton.tap()
            } else {
                XCTFail("Google Sign-In alert did not appear")
            }

        
        let googleWebView = app.webViews.firstMatch
        XCTAssertTrue(googleWebView.waitForExistence(timeout: 5), "Google sign-in webview should appear")
    }
    
    func testSignInFailure_UserCancelsSignIn() {
        let app = XCUIApplication()
        app.launch()

        let signInButton = app.buttons["signInButton"]
        XCTAssertTrue(signInButton.exists, "Sign-In button should exist")
        
        signInButton.tap()
        
        // Handle Firebase alert if it appears
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        let continueButton = springboard.buttons["Continue"]
        
        if continueButton.waitForExistence(timeout: 3) {
            continueButton.tap()
        }
        
        // Check that Google Sign-In WebView appears
        let googleSignInWebView = app.webViews.firstMatch
        XCTAssertTrue(googleSignInWebView.waitForExistence(timeout: 5), "Google Sign-In WebView should appear")
        
        // Simulate user canceling sign-in
        let cancelButton = app.buttons["Cancel"] // Change this based on actual UI
        XCTAssertTrue(cancelButton.waitForExistence(timeout: 3), "Cancel button should exist")
        cancelButton.tap()
        
        // Ensure the user is still on the Sign-In screen (Sign-In button should be visible)
        XCTAssertTrue(signInButton.waitForExistence(timeout: 3), "Sign-In button should reappear after canceling sign-in")
    }

    //TODO: Need to check how to test navigation to main/home screen after successful Signin.
}
