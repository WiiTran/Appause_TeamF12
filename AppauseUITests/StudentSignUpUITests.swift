//
//  StudentSignUpUITests.swift
//  AppauseUITests
//
//  Created by Huy Tran on 10/15/24.
//

import XCTest

final class StudentSignUpUITests: XCTestCase {

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
        app.buttons["Accept"].tap()
        
        let studentStaticText = app/*@START_MENU_TOKEN@*/.staticTexts["Student"]/*[[".buttons[\"Student\"].staticTexts[\"Student\"]",".staticTexts[\"Student\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        studentStaticText.tap()
        app.buttons["Sign up here!"].tap()
        app/*@START_MENU_TOKEN@*/.images["Student"]/*[[".buttons[\"Student\"].images[\"Student\"]",".images[\"Student\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.textFields["First Name"].tap()
        
        
        // Wait for First Name field and type text
            let studentFirst = app.textFields["First Name"]
            XCTAssertTrue(studentFirst.waitForExistence(timeout: 5), "First Name text field does not exist")
        studentFirst.tap()
        studentFirst.typeText("Huy")
            
            // Last Name
            let studentLast = app.textFields["Last Name"]
            studentLast.tap()
            studentLast.typeText("Tran")
            
            // Email
            let studentEmail = app.textFields["Email"]
        studentEmail.tap()
        studentEmail.typeText("huyqtran@student.sanjuan.edu")
            
        // Ensure the password field exists and tap it
        let passwordSecureTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordSecureTextField.exists, "Password secure text field should exist")
        
        // Tap the password field to activate it
        passwordSecureTextField.tap()
        
        // Add a small delay to ensure the field is in focus
        sleep(1)  // Wait for 1 second
        
        // Type the password
        passwordSecureTextField.typeText("123456")
        
        // Ensure the confirmpassword field exists and tap it
        let confirmpasswordSecureTextField = app.secureTextFields["Password"]
        XCTAssertTrue(confirmpasswordSecureTextField.exists, "Password secure text field should exist")
        
        // Tap the password field to activate it
        confirmpasswordSecureTextField.tap()
        
        // Add a small delay to ensure the field is in focus
        sleep(1)  // Wait for 1 second
        
        // Type the password
        confirmpasswordSecureTextField.typeText("123456")
        
                                
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        
    }

    
        
    
}
