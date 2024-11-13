//
//  TeacherAllRequestAppsUITests.swift
//  AppauseUITests
//
//  Created by Huy Tran on 11/13/24.
//

import XCTest

final class TeacherAllRequestAppsUITests: XCTestCase {

  
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Tap accept button to proceed
        app.buttons["Accept"].tap()

        // Tap the "Student" button to go to student login
        app.buttons["Teacher"].tap()

        // Enter email in the email text field
        let emailTextField = app.textFields["Email"]
        XCTAssertTrue(emailTextField.exists, "Email text field should exist")
        emailTextField.tap()
        emailTextField.typeText("didit.work@sanjuan.edu")
        
        // Ensure the password field exists and tap it
        let passwordSecureTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordSecureTextField.exists, "Password secure text field should exist")
        
        // Tap the password field to activate it
        passwordSecureTextField.tap()
        
        // Add a small delay to ensure the field is in focus
        sleep(1)  // Wait for 1 second
        
        // Type the password
        passwordSecureTextField.typeText("Teach@12345Secure")
        
        // Tap the Login button
        let loginButton = app.buttons["Login"]
        XCTAssertTrue(loginButton.exists, "Login button should exist")
        loginButton.tap()
        sleep(2)  // Wait for 1 second
        
        
        
        app.buttons["Requests"].tap()
        sleep(2)  // Wait for 2 second
        
        app.buttons["My Classes"].tap()
        sleep(2)  // Wait for 2 second
        
        app.buttons["Schedule"].tap()
        sleep(2)  // Wait for 2 second
        
        app.buttons["More"].tap()
        sleep(2)  // Wait for 2 second
        
        
        
        
        

       
//
//        // Ensure the logout button appears after login
//        let logoutButton = app.buttons["Logout"]
//        XCTAssertTrue(logoutButton.waitForExistence(timeout: 5), "Logout button should appear after login")
//
//        // Tap logout to complete the test
//        logoutButton.tap()
    }
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
