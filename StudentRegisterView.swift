//
//  StudentRegisterView.swift
//  Project190
//
//  Created by Mark Zhang on 4/19/23.
//  Updated by Luis Campos on 10/5/23.

import SwiftUI
import Foundation //used for regex verification
import KeychainSwift // used to save registration data


struct StudentRegisterView: View {
    //Add this binding state for transitions from view to view
    @Binding var showNextView: DisplayState
    
    //variables used to store registration data before being sent to the keychain
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var passConfirm: String = ""
    
    //String variable used in error messages
    @State private var registerError: String = " "
    
    @State private var passwordStatus: String = ""
    @State private var confirmStatus: String = ""
    
    //keychain variable
    let keychain = KeychainSwift()
    
    var body: some View {
        VStack{
            
            Button(action: {
                withAnimation {
                    //show nextView .whateverViewYouWantToShow defined in ContentView Enum
                    showNextView = .login}
            }) {
                Text(" < Return to Login")
                    .fontWeight(.bold)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(100)
                    .padding(.trailing, 130)
                    .padding(.bottom, 30)
            }
            Text("Student Registration")
                .font(.custom("large", size: 25))
                .padding()
            
            Text(registerError)
                .fontWeight(.bold)
                .foregroundColor(.red)
            
            TextField(
                "First Name",
                text: $firstName
            )
            .disableAutocorrection(true)
            .padding(10)
            .background(Color.gray.opacity(0.2))
            .multilineTextAlignment(.leading)
            .cornerRadius(10)
            .padding([.trailing, .leading], 50)
            .padding(.bottom, 5)

            
            TextField(
                "Last Name",
                text: $lastName
            )
            .disableAutocorrection(true)
            .padding(10)
            .background(Color.gray.opacity(0.2))
            .multilineTextAlignment(.leading)
            .cornerRadius(10)
            .padding([.trailing, .leading], 50)
            .padding(.bottom, 5)
            
            TextField(
                "Email Address",
                text: $email
            )
            .disableAutocorrection(true)
            .padding(10)
            .background(Color.gray.opacity(0.2))
            .multilineTextAlignment(.leading)
            .cornerRadius(10)
            .padding([.trailing, .leading], 50)
            .padding(.bottom, 10)
            
            if(passwordStatus == "visible"){
                HStack{
                    TextField("Password", text: $password)
                        .padding(10)
                        .background(Color.gray.opacity(0.2))
                        .multilineTextAlignment(.leading)
                        .cornerRadius(10)
                        .padding(.leading, 50)
                        .padding(.bottom, 5)
                    Button(action:{passwordStatus="hidden"}){
                        Image(systemName:"eye.slash")
                            .foregroundColor(Color.black)
                            .fontWeight(.bold)
                            .padding(.trailing, 13)
                    }
                }
                .padding(.bottom, 5)
            }
            else{
                HStack{
                    SecureField("Password", text: $password)
                        .padding(10)
                        .background(Color.gray.opacity(0.2))
                        .multilineTextAlignment(.leading)
                        .cornerRadius(10)
                        .padding(.leading, 50)
                        .padding(.bottom, 5)
                    Button(action:{passwordStatus="visible"}){
                        Image(systemName:"eye")
                            .foregroundColor(Color.black)
                            .fontWeight(.bold)
                            .padding(.trailing, 13)
                    }
                }
                .padding(.bottom, 5)
            }
            if(confirmStatus=="visible"){
                HStack{
                    TextField("Confirm Password", text: $passConfirm)
                        .padding(10)
                        .background(Color.gray.opacity(0.2))
                        .multilineTextAlignment(.leading)
                        .cornerRadius(10)
                        .padding(.leading, 50)
                        .padding(.bottom, 5)
                    Button(action:{confirmStatus="hidden"}){
                        Image(systemName:"eye.slash")
                            .foregroundColor(Color.black)
                            .fontWeight(.bold)
                            .padding(.trailing, 13)
                    }
                }
                .padding(.bottom, 5)
            }
            else{
                HStack{
                    SecureField("Confirm Password", text: $passConfirm)
                        .padding(10)
                        .background(Color.gray.opacity(0.2))
                        .multilineTextAlignment(.leading)
                        .cornerRadius(10)
                        .padding(.leading, 50)
                        .padding(.bottom, 5)
                    Button(action:{confirmStatus="visible"}){
                        Image(systemName:"eye")
                            .foregroundColor(Color.black)
                            .fontWeight(.bold)
                            .padding(.trailing, 13)
                    }
                }
                .padding(.bottom, 5)
            }
            
            Button(action: {
                if (firstName == "" || lastName == "" || email == "" || password == "" || passConfirm == ""){
                    registerError = "Please fill in all of the fields."
                }
                else if (validateEmail(email) == false){
                    registerError = "Please enter a valid email address."
                }
                else if (validatePassword(password) == false){
                    registerError = "Password Requires:\nat least 6 Characters and a Number"
                }
                else if (password != passConfirm){
                    registerError = "Passwords do not match. Try again."
                }
                else{
                    registerError = " " //resets the error message if there is one
                    
                    //adds information into the keychain
                    keychain.set(email.lowercased(), forKey: "studentUserKey")
                    keychain.set(password, forKey: "studentPassKey")
                    keychain.set(firstName, forKey: "studentFirstNameKey")
                    keychain.set(lastName, forKey: "studentLastNameKey")
                    
                    withAnimation {
                        //show nextView .whateverViewYouWantToShow defined in ContentView Enum
                        showNextView = .login
                    }
                }
            }) {
                Text("+ Register")
                    .padding()
                    .fontWeight(.bold)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(100)
                    .padding(.leading, 200)
                    .padding(.bottom, 100)
            }
        }
    }
    
    func validateEmail(_ email: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$", options: [.caseInsensitive])
        return regex.firstMatch(in: email, options: [], range: NSRange(location: 0, length: email.utf16.count)) != nil
    }
    
    func validatePassword(_ password: String) -> Bool{
        let passwordLength = password.count
        let regex = ".*[0-9]+.*"
        let checkPass = NSPredicate(format: "SELF MATCHES %@", regex)
        let hasNum = checkPass.evaluate(with: password)
        var result: Bool = true
        
        // checks if password contains numbers and if the length of password is short
        if (hasNum == false || passwordLength < 6){
            result.toggle()
        }
        
        return result
    }
}

struct StudentRegisterView_Previews: PreviewProvider {
    @State static private var showNextView: DisplayState = .studentRegister
    
    static var previews: some View {
        StudentRegisterView(showNextView: $showNextView)
    }
}
