//
//  TeacherSignUpUITests.swift
//  AppauseUITests
//
//  Created by Huy Tran on 10/11/24.
//
import XCTest

final class TeacherSignUpUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {}

func testTeacherSignUp() throws {
        let app = XCUIApplication()
        app.launch()
        app.buttons["Accept"].tap()
        
        
        let teacherButton = app.buttons["Teacher"]
        XCTAssertTrue(teacherButton.waitForExistence(timeout: 5), "Teacher button should exist")
        teacherButton.tap()

        app.buttons["Sign up here!"].tap()

       
        let teacherRoleButton = app.buttons["Teacher"]
        XCTAssertTrue(teacherRoleButton.waitForExistence(timeout: 5), "Teacher role button should exist")
        teacherRoleButton.tap()

        // Fill in the registration form
        let teacherFirst = app.textFields["First Name"]
        XCTAssertTrue(teacherFirst.waitForExistence(timeout: 5), "First Name text field does not exist")
        teacherFirst.tap()
        teacherFirst.typeText("Huy")
        
        let teacherLast = app.textFields["Last Name"]
        XCTAssertTrue(teacherLast.exists, "Last Name text field should exist")
        teacherLast.tap()
        teacherLast.typeText("Tran")
        
        let teacherEmail = app.textFields["Email"]
        XCTAssertTrue(teacherEmail.exists, "Email text field should exist")
        teacherEmail.tap()
        teacherEmail.typeText("huyqtran@student.sanjuan.edu")
        
  
    let passwordSecureTextField = app.secureTextFields["Password"]
    app.secureTextFields["Password"].tap()
    passwordSecureTextField.typeText("123456")
        
    let confirmPasswordSecureTextField = app.secureTextFields["Confirm Password"]
    app.secureTextFields["Confirm Password"].tap()
    confirmPasswordSecureTextField.typeText("123456")
        
        // Complete registration
        let registerButton = app.buttons["Register"]
        XCTAssertTrue(registerButton.exists, "Register button should exist")
        registerButton.tap()
    
   
    
  
    
    }
}
