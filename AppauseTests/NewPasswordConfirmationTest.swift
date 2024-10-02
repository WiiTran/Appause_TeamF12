//
//  NewPasswordConfirmationTest.swift
//  AppauseTests
//
//  Created by Huy Tran on 10/1/24.
//

import XCTest
@testable import Appause

final class NewPasswordConfirmationTest: XCTestCase {

    func testPasswordEquality(){
        let newPasswords = ["SM1rio", "S0n3cH", "K3rbyR", "P3k1ch5", "Peach", "Yoshi", "Micky2", "Woody"]
        let confirmPasswords = ["SM1rio", "T13lsF", "M2t1Kn", "P3k1ch5", "Peach", "Wario", "Luigi", "B5zzLY"]
        let equal=Equality()
        let valid=Validate()
        var word=0
        while word<newPasswords.count&&word<confirmPasswords.count{
            let newPass = newPasswords[word]
            let confirmPass = confirmPasswords[word]
            let equality = equal.passwordEquality(_newPass: newPass, _confirmPass: confirmPass)
            let newValid = valid.validatePassword(newPass)
            let confirmValid = valid.validatePassword(confirmPass)
            if(equality==true){
                print(newPass+" "+confirmPass+" these passwords match one another.\n")
                XCTAssertTrue(equality)
            }
            else{
                if(newValid==true&&confirmValid==true){
                    print(newPass+" "+confirmPass+" even though these passwords are valid they are different.\n")
                    XCTAssertFalse(equality)
                }
                else if(newValid==false&&confirmValid==false){
                    if(newPass==confirmPass){
                        print(newPass+" "+confirmPass+" even though these passwords match they are invalid.\n")
                        XCTAssertFalse(equality)
                    }
                    else{
                        print(newPass+" "+confirmPass+" not only are these passwords different but they are also invalid.\n")
                        XCTAssertFalse(equality)
                    }
                }
                else if(newValid==false&&confirmValid==true){
                    print(newPass+" this password is not valid.\n")
                    XCTAssertFalse(equality)
                }
                else if(newValid==true&&confirmValid==false){
                    print(confirmPass+" this password is not valid.\n")
                    XCTAssertFalse(equality)
                }
            }
            word=word+1
        }
    }
}
