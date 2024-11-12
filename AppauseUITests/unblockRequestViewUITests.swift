import XCTest

final class UnblockRequestViewUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        // Set up the application
        app = XCUIApplication()
        continueAfterFailure = false
        app.launch()
    }

    override func tearDownWithError() throws {
        // Clean up any resources or states
    }

    func test_submitUnblockRequest() throws {
        // Locate the text fields and buttons
        let studentIDTextField = app.textFields["studentIDTextField"]
        let appNameTextField = app.textFields["appNameTextField"]
        let reasonTextField = app.textFields["reasonTextField"]
        let submitButton = app.buttons["Submit Request"]
        let statusLabel = app.staticTexts["Current Status: Pending"]

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
        XCTAssertTrue(statusLabel.label.contains("Pending"), "The status should remain 'Pending' after checking.")
    }
}
