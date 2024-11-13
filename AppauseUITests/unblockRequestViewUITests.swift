import XCTest

final class UnblockRequestViewUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        // Set up the application
//        app = XCUIApplication()
        continueAfterFailure = false
//        app.launch()
    }

    override func tearDownWithError() throws {
        // Clean up any resources or states
    }

    func test_submitUnblockRequest() throws {
        
        let app = XCUIApplication()
        app.launch()

        // Tap accept button to proceed
        app.buttons["Accept"].tap()

        // Tap the "Student" button to go to student login
        app.buttons["Student"].tap()

        // Enter email in the email text field
        let emailTextField = app.textFields["Email"]
        XCTAssertTrue(emailTextField.exists, "Email text field should exist")
        emailTextField.tap()
        emailTextField.typeText("223344@student.sanjuan.edu")
        
        // Ensure the password field exists and tap it
        let passwordSecureTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordSecureTextField.exists, "Password secure text field should exist")
        
        // Tap the password field to activate it
        passwordSecureTextField.tap()
        
        // Add a small delay to ensure the field is in focus
        sleep(1)  // Wait for 1 second
        
        // Type the password
        passwordSecureTextField.typeText("Password123.")
        
        // Tap the Login button
        let loginButton = app.buttons["Login"]
        XCTAssertTrue(loginButton.exists, "Login button should exist")
        loginButton.tap()
        
        
     
        sleep(2)  // Wait for 1 second
        // Tap the Submit Request button
//        let requestButton = app.buttons["Submit Reqest"]
//        XCTAssertTrue(requestButton.exists, "Request button should exist")
//        requestButton.tap()
        app.buttons["Submit Request"].tap()
        
        
        sleep(2)  // Wait for 1 second
        
        // Locate the text fields and buttons
        let studentIDTextField = app.textFields["studentIDTextField"]
        let appNameTextField = app.textFields["appNameTextField"]
        let reasonTextField = app.textFields["reasonTextField"]
        let submitButton = app.buttons["Submit Request"]
        let statusLabel = app.staticTexts["Current Status: Pending"]

        sleep(2)  // Wait for 1 second
        // Simulate user input
        studentIDTextField.tap()
        studentIDTextField.typeText("123456")

        appNameTextField.tap()
        appNameTextField.typeText("YouTube")

        reasonTextField.tap()
        reasonTextField.typeText("Requesting unblock for educational purposes.")

        // Tap submit button
        submitButton.tap()

        // Check if the status is updated to "Pending"
        XCTAssertTrue(statusLabel.exists, "Status label should say 'Pending' after submission.")
        
        // Optionally, you could simulate a check for the request status:
        let checkStatusButton = app.buttons["Check Status"]
        checkStatusButton.tap()
        
        // After checking status, ensure it's still "Pending"
//        XCTAssertTrue(statusLabel.label.contains("Pending"), "The status should remain 'Pending' after checking.")
    }
}
