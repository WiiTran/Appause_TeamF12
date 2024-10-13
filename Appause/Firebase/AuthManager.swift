//
//  AuthManager.swift
//  Appause
//
//  Created by Luke Simoni on 9/17/24.
//

import Foundation
import FirebaseAuth

struct AuthDataResult {
    let uid: String?
    let email: String?
    let fname: String?
    let lname: String?
    
    init() {
        self.uid = nil
        self.email = nil
        self.fname = nil
        self.lname = nil
    }
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.fname = nil
        self.lname = nil
    }
    
    init(user: User, fname: String, lname: String) {
        self.uid = user.uid
        self.email = user.email!
        self.fname = fname
        self.lname = lname
    }
}


final class AuthManager {
    
    static let sharedAuth = AuthManager()
    init() {}
    
    func createUser(email: String, password: String, fname: String, lname: String) async throws -> AuthDataResult{
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResult(user: authDataResult.user, fname: fname, lname: lname)
    }
    
    func loginUser(email: String, password: String) async throws -> AuthDataResult {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResult(user: authDataResult.user)
    }
}
