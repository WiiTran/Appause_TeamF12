//
//  EmailValidationTest.swift
//  AppauseTests
//
//  Created by Huy Tran on 10/1/24.
//

import XCTest
@testable import Appause

final class EmailValidationTest: XCTestCase
{
    
    func testEmailValidation()
    {
        // test emails
        let emails = ["", "a@b.c", "abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz@abcdefghijkyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz", " test@example.com", "test@example.com ", "user%name@example.com", "user..name@example.com", ".user@example.com", "user@example.com.", "üser@example.com"]
        let valid = Validate()
        
        // loop through email array
        print("\n")
        for email in emails
        {
            let check = valid.validateEmail(email)
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
