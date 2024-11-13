//
//  EmailValidationStudent.swift
//  AppauseTests
//
//  Created by Huy Tran on 11/13/24.
//

import XCTest

@testable import Appause

final class EmailValidationTestStudent: XCTestCase
{
    
    func testEmailValidation()
    {
        // test emails
        let emails = ["test@example.com ", "user..name@example.com","223344@student.sanjuan.edu","22334@student.sanjuan.edu","aaaaaa@student.sanjuan.edu","222222@sanjuan.edu","123456@sanjuan.edu"]
        let valid = Validate()
        
        // loop through email array
        print("\n")
        for email in emails
        {
            let check = valid.validateEmailStudent(email)
            if (check == false)
            {
                print(email + " is invalid email\n")
                XCTAssertFalse(check)
            }
            else
            {
                print(email + " is valid email\n")
                XCTAssertTrue(check)
            }
        }
    }
}
