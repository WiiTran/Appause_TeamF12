//
//  StudentSettingsView.swift
//  Appause_TeamF12_HTr
//
//  Created by Dash on 4/21/24.
//

import SwiftUI
import CoreBluetooth
import Combine
import KeychainSwift

struct ChangePasswordView: View {
    @Binding var showNextView: DisplayState
    @State private var registerError: String = " "
    
    @State var firstButton = "MAIN / SETTINGS"
    @State var secondButton = "Change Password"
    
    @State var fifthButton = "Dark Mode"
    
    @ObservedObject var bluetoothManager = BluetoothManager()
    
    @State var isBluetoothEnabled = false
    var centralManager: CBCentralManager!
    var timer: AnyCancellable?
    
    //environment variable used in navigation when the back button is pressed during the password reset process
    @EnvironmentObject var viewSwitcher: ViewSwitcher
    
    let keychain = KeychainSwift()
 
    @State var password: String = ""
    @State var newPassword: String = ""
    @State var confirmPassword: String = ""

    @State private var colorScheme = btnStyle.getStudentScheme()
    
    // @State private var teacherPassword: String = ""
    @State private var passwordStatus: String = ""
    
    struct TextFieldWithEyeIcon: View {
        // Placeholder text for the text field
        var placeholder: String
        
        // Binding to a text property, so changes to this text will be reflected externally
        @Binding var text: String
        
        // A flag indicating whether this text field should display as a secure (password) field
        var isSecure: Bool
        
        // Binding to the visibility state of the password (visible or hidden)
        @Binding var visibility: String
        
        var body: some View {
            HStack {
                if isSecure {
                    // SecureField is used for password input
                    SecureField(placeholder, text: $text)
                        .padding(.leading, 10)
                } else {
                    // TextField is used for non-password input
                    TextField(placeholder, text: $text)
                        .padding(.leading, 10)
                }
                
                // Button for toggling password visibility
                Button(action: {
                    // Toggle visibility state between "visible" and "hidden"
                    visibility = isSecure ? "visible" : "hidden"
                }) {
                    // Show the "eye" icon for password visibility, or "eye.slash" for hidden
                    Image(systemName: isSecure ? "eye" : "eye.slash")
                        .foregroundColor(Color.black)
                        .fontWeight(.bold)
                }
            }
            .font(.system(size: 20))
            .padding()
            .cornerRadius(10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 1) // Change border color to black
                    .frame(width: 325, height: 50)
            )
            .disableAutocorrection(true)
            .autocapitalization(.none)
        }
    }
        
    // Function to update first name and last name
    private func updatePassword() {
        // Perform password validation here
        if (newPassword == confirmPassword) {} else {
            registerError = "Passwords do not match. Try again."
            // Show an alert or some feedback to the user
            return
        }
        guard validatePassword(password) else {
            registerError = "Incorrect Password. Try again."
            // Show an alert or some feedback to the user
            return
        }

        // Assuming the password is validated successfully
        // Update first name and last name
        keychain.set(newPassword, forKey: "passKey")
        
        // Clear password fields after update
        password = ""
        newPassword = ""
        confirmPassword = ""
    }

    // Function to validate password
    func validatePassword(_ password: String) -> Bool
    {
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
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                Button(action: {
                    /* sets the last page that the user was at before entering the password reset process to
                     the login page so that if the user presses the back button it brings the user
                     back to the login page. */
                    //viewSwitcher.lastView = "login"
                    withAnimation {
                        showNextView = .emailCode
                    }
                }) {
                    Text("Menu")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .frame(width: 100, height: 20, alignment: .center)
                }
                .padding()
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 10) // Apply the corner radius to the overlay
                        .stroke(Color.black, lineWidth: 1) // Add a border with 1 point width
                )
            }
            VStack {
                HStack {
                    Spacer()
                    Text("Change Password")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .font(.system(size: 36))
                        .padding(.top, 20)
                    Spacer()
                }
                HStack {
                    Spacer()
                    Text(registerError)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                        .padding(.top, 5)
                    Spacer()
                }
            }
            VStack (alignment: .leading){
                Text("New Password:")
                    .foregroundColor(.black)
                    .font(.system(size: 24))
                    .padding()
                    .alignmentGuide(.leading) { dimension in
                        dimension[.leading]
                    }
                if passwordStatus == "visible"
                {
                    TextFieldWithEyeIcon(placeholder: "Confirm Password", text: $newPassword, isSecure: false, visibility: $passwordStatus)
                }
                else
                {
                    TextFieldWithEyeIcon(placeholder: "Confirm Password", text: $newPassword, isSecure: true, visibility: $passwordStatus)
                }
                //Spacer()
                Text("Confirm Password:")
                    .foregroundColor(.black)
                    .font(.system(size: 24))
                    .padding()
                    .alignmentGuide(.leading) { dimension in
                        dimension[.leading]
                    }
                if passwordStatus == "visible"
                {
                    TextFieldWithEyeIcon(placeholder: "Confirm Password", text: $confirmPassword, isSecure: false, visibility: $passwordStatus)
                }
                else
                {
                    TextFieldWithEyeIcon(placeholder: "Confirm Password", text: $confirmPassword, isSecure: true, visibility: $passwordStatus)
                }
                //Spacer()
                Text("Current Password:")
                    .foregroundColor(.black)
                    .font(.system(size: 24))
                    .padding()
                    .alignmentGuide(.leading) { dimension in
                        dimension[.leading]
                    }
                if passwordStatus == "visible"
                {
                    TextFieldWithEyeIcon(placeholder: "Current Password", text: $password, isSecure: false, visibility: $passwordStatus)
                }
                else
                {
                    TextFieldWithEyeIcon(placeholder: "Current Password", text: $password, isSecure: true, visibility: $passwordStatus)
                }
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        updatePassword()
                        withAnimation {
                            showNextView = .mainStudent
                        }
                    }) {
                        Text("Save Changes")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 300, height: 20, alignment: .center)
                    }
                    .padding()
                    .background(Color.black)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10) // Apply the corner radius to the overlay
                            .stroke(Color.black, lineWidth: 1) // Add a border with 1 point width
                    )
                    Spacer()
                }
                Spacer()
            }
            Spacer()
        }
        .frame(maxWidth: 350, alignment: .leading)
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    @State static private var showNextView: DisplayState = .changePasswordView
    static var previews: some View {
        ChangePasswordView(showNextView: $showNextView)
    }
}

