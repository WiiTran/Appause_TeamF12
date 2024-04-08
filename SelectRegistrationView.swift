//
//  SelectRegistrationView.swift
//  Project190
//
//  Created by Mark Zhang on 9/28/23.
//

import SwiftUI
import KeychainSwift

struct SelectRegistrationView: View
{
    @Binding var showNextView: DisplayState
    @State private var registerError: String = " "
    
    @State private var studentFirstName: String = ""
    @State private var studentLastName: String = ""
    @State private var studentEmail: String = ""
    @State private var studentPassword: String = ""
    @State private var studentPassConfirm: String = ""
    
    @State private var teacherFirstName: String = ""
    @State private var teacherLastName: String = ""
    @State private var teacherEmail: String = ""
    @State private var teacherPassword: String = ""
    @State private var teacherPassConfirm: String = ""
    
    
    @State private var confirmStatus: String = ""
    @State private var passwordStatus: String = ""
    
    @State private var showTeacherRegistrationFields = false
    @State private var showStudentRegistrationFields = false
    
    @State var buttonColorBottom = Color.black
    @State var buttonColorTop = Color.black
    
    let keychain = KeychainSwift()
    
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
                } else {
                    // TextField is used for non-password input
                    TextField(placeholder, text: $text)
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
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
            .frame(width: 370)
            .disableAutocorrection(true)
            .autocapitalization(.none)
        }
    }
    
    
    var body: some View {
        VStack{
            Text("Are you a teacher or a student?")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding([.top, .bottom], 15)
            
            Text(registerError)
                .fontWeight(.bold)
                .foregroundColor(.red)
                .padding(.bottom, 20)
            
            HStack
            {
                Button(action:
                        {
                    let registeredUsername = keychain.get("teacherUserKey")
                    let registeredPassword = keychain.get("teacherPassKey")
                    
                    withAnimation
                    {
                        showTeacherRegistrationFields.toggle()
                        showStudentRegistrationFields = false
                        updateButtonColors()
                    }
                    
                })
                {
                    VStack
                    {
                        Text("Teacher")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 150, height: 20, alignment: .center)
                        Image(systemName: "graduationcap")
                            .fontWeight(.bold)
                            .imageScale(.large)
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .background(buttonColorTop)
                .cornerRadius(10)
                
                Button(action:
                        {
                    let registeredUsername = keychain.get("studentUserKey")
                    let registeredPassword = keychain.get("studentPassKey")
                    
                    withAnimation
                    {
                        //showNextView = .login
                        showStudentRegistrationFields.toggle()
                        showTeacherRegistrationFields = false
                        updateButtonColors()                    }
                })
                {
                    VStack{
                        Text("Student")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 150, height: 16, alignment: .center)
                        Image(systemName: "studentdesk")
                            .padding(4)
                            .fontWeight(.bold)
                            .imageScale(.large)
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .background(buttonColorBottom)
                .cornerRadius(10)
            }
            //.padding(.bottom, 50)
            
            if showTeacherRegistrationFields
            {
                VStack
                {
                    TextField(
                        "First Name",
                        text: $teacherFirstName
                    )
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .frame(width: 370)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    
                    TextField(
                        "Last Name",
                        text: $teacherLastName
                    )
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .frame(width: 370)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    
                    TextField(
                        "Email",
                        text: $teacherEmail
                    )
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .frame(width: 370)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    
                    if passwordStatus == "visible"
                    {
                        TextFieldWithEyeIcon(placeholder: "Password", text: $teacherPassword, isSecure: false, visibility: $passwordStatus)
                    }
                    else
                    {
                        TextFieldWithEyeIcon(placeholder: "Password", text: $teacherPassword, isSecure: true, visibility: $passwordStatus)
                    }
                    
                    if(confirmStatus=="visible")
                    {
                        TextFieldWithEyeIcon(placeholder: "Confirm Password", text: $teacherPassConfirm, isSecure: false, visibility: $confirmStatus)
                    }
                    else
                    {
                        TextFieldWithEyeIcon(placeholder: "Confirm Password", text: $teacherPassConfirm, isSecure: true, visibility: $confirmStatus)
                    }
                    Button(action:
                            {
                        if (teacherFirstName == "" || teacherLastName == "" || teacherEmail == "" || teacherPassword == "" || teacherPassConfirm == "")
                        {
                            registerError = "Please fill in all of the fields."
                        }
                        else if (validateEmail(teacherEmail) == false)
                        {
                            registerError = "Please enter a valid email address."
                        }
                        else if (validatePassword(teacherPassword) == false)
                        {
                            registerError = "Password Requires:\nat least 6 Characters and a Number"
                        }
                        else if (teacherPassword != teacherPassConfirm){
                            registerError = "Passwords do not match. Try again."
                        }
                        else
                        {
                            registerError = ""
                            
                            keychain.set(teacherEmail.lowercased(), forKey: "teacherUserKey")
                            keychain.set(teacherPassword, forKey: "teacherPassKey")
                            keychain.set(teacherFirstName, forKey: "teacherFirstNameKey")
                            keychain.set(teacherLastName, forKey: "teacherLastNameKey")
                            
                            withAnimation
                            {
                                showNextView = .login
                            }
                        }
                    })
                    {
                        Text("Register")
                            .padding()
                            .frame(width: 370)
                            .fontWeight(.bold)
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.bottom, 25)
                            .frame(minWidth: 2000)
                    }
                    
                    HStack {
                        Spacer()
                        Text("Already have an account?")
                            //.padding(.leading, 15)
                        
                        Button(action: {
                            withAnimation {
                                showNextView = .login
                            }
                        }) {
                            Text("Sign in here!")
                                .foregroundColor(.blue)
                                .padding(.leading, -4.0)
                        }
                        Spacer()
                    }                }
            }
            
            if showStudentRegistrationFields
            {
                VStack
                {
                    TextField("First Name", text: $studentFirstName)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .frame(width: 370)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    
                    TextField("Last Name", text: $studentLastName)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .frame(width: 370)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    
                    TextField("Email", text: $studentEmail)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .frame(width: 370)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    
                    if passwordStatus == "visible"
                    {
                        TextFieldWithEyeIcon(placeholder: "Password", text: $studentPassword, isSecure: false, visibility: $passwordStatus)
                    }
                    else
                    {
                        TextFieldWithEyeIcon(placeholder: "Password", text: $studentPassword, isSecure: true, visibility: $passwordStatus)
                    }
                    
                    if(confirmStatus=="visible")
                    {
                        TextFieldWithEyeIcon(placeholder: "Confirm Password", text: $studentPassConfirm, isSecure: false, visibility: $confirmStatus)
                    }
                    else
                    {
                        TextFieldWithEyeIcon(placeholder: "Confirm Password", text: $studentPassConfirm, isSecure: true, visibility: $confirmStatus)
                    }
                    
                    Button(action: {
                        if (studentFirstName == "" || studentLastName == "" || studentEmail == "" || studentPassword == "" || studentPassConfirm == ""){
                            registerError = "Please fill in all of the fields."
                        }
                        else if (validateEmail(studentEmail) == false){
                            registerError = "Please enter a valid email address."
                        }
                        else if (validatePassword(studentPassword) == false){
                            registerError = "Password Requires:\nat least 6 Characters and a Number"
                        }
                        else if (studentPassword != studentPassConfirm){
                            registerError = "Passwords do not match. Try again."
                        }
                        else{
                            registerError = " " //resets the error message if there is one
                            
                            //adds information into the keychain
                            keychain.set(studentEmail.lowercased(), forKey: "studentUserKey")
                            keychain.set(studentPassword, forKey: "studentPassKey")
                            keychain.set(studentFirstName, forKey: "studentFirstNameKey")
                            keychain.set(studentLastName, forKey: "studentLastNameKey")
                            
                            withAnimation {
                                //show nextView .whateverViewYouWantToShow defined in ContentView Enum
                                showNextView = .login
                            }
                        }
                    })
                    //.padding(.bottom)
                    {
                        Text("Register")
                            .padding()
                            .frame(width: 370)
                            .fontWeight(.bold)
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        //.padding(.leading, 200)
                            .padding(.bottom, 25)
                    }
                    
                    HStack {
                        Spacer()
                        Text("Already have an account?")
                            //.padding(.leading, 15)
                        
                        Button(action: {
                            withAnimation {
                                showNextView = .login
                            }
                        }) {
                            Text("Sign in here!")
                                .foregroundColor(.blue)
                                .padding(.leading, -4.0)
                        }
                        Spacer()
                    }
                }
            }
        }
    }
    
    // Function to update button colors based on selection
    private func updateButtonColors() {
        if showTeacherRegistrationFields && !showStudentRegistrationFields {
            buttonColorTop = .black
            buttonColorBottom = .gray
        } else if !showTeacherRegistrationFields && showStudentRegistrationFields {
            buttonColorTop = .gray
            buttonColorBottom = .black
        } else {
            buttonColorTop = .black
            buttonColorBottom = .black
        }
    }

    func validateEmail(_ email: String) -> Bool
    {
        let regex = try! NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$", options: [.caseInsensitive])
        return regex.firstMatch(in: email, options: [], range: NSRange(location: 0, length: email.utf16.count)) != nil
    }
    
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
}

struct SelectRegistrationView_Previews: PreviewProvider
{
    @State static private var showNextView: DisplayState = .selectRegistration
    
    static var previews: some View
    {
        SelectRegistrationView(showNextView: $showNextView)
    }
}
