//  LoginView.swift
//  Appause
//  Created by Huy Tran on 4/16/24.

import SwiftUI
import MessageUI
import KeychainSwift
import Combine
import CoreHaptics
import LocalAuthentication
import FirebaseAuth

var currentLoggedInUser: String? = nil
private var isTeacherLogin = false

struct LoginView: View {
    public var keychain = KeychainSwift()
    
    // Environment variable for switching views
    @EnvironmentObject var viewSwitcher: ViewSwitcher
    
    @State private var isFaceIDAuthenticated = false
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    @State private var showErrorMessages = false
    @State private var errorMessages = ""
    @State private var shakeOffset: CGFloat = 0.0
    
    // Binding to control the view state
    @Binding var showNextView: DisplayState
    
    // Button properties
    @State var buttonNameTop = "Teacher"
    @State var buttonColorTopIdle = Color.gray
    @State var buttonColorTopActive = Color.black
    @State var buttonColorLogin = Color.black
    @State var buttonNameBottom = "Student"
    @State var buttonColorBottomIdle = Color.gray
    @State var buttonColorBottomActive = Color.black
    @State var buttonColorTopSucess = Color.green
    @State var textFieldOpacity = Color.gray.opacity(0.2)
    @State var buttonColorTop = Color.black
    @State var buttonColorBottom = Color.black
    @State var showTextFields = false
    @State var showCodeField = false
    
    // Username and password text fields for teacher and student
    @State var usernameText = ""
    @State var passwordText = ""
    @State var studentPasswordText = ""
    @State var studentUsernameText = ""
    @State var codeText = ""
    @State var setUsername = ""
    @State var setPassword = ""
    
    @State var isLoginSuccessful = false
    @State var isRegistrationSuccessful = false
    @State var isStudentRegistrationSuccessful = false
    @State var isStudentLoginSuccessful = false
    @State private var isResetPasswordViewActive = false
    @State private var selectedLoginType: LoginType? = nil
    
    enum LoginType {
        case teacher
        case student
    }

    // Password visibility
    @State var studentPassVisibility: String = ""
    @State var teacherPassVisibility: String = ""
    
    // Helper strings to parse username and correctly sort account type
    @State var tempStudentString: String = ""
    @State var tempString: [String] = []
    @AppStorage("isUserLoggedIn") var isUserLoggedIn: Bool = false // Track login status
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false // Track dark mode preference

    // Custom SwiftUI view to create a text field with an optional eye icon for password visibility
    struct TextFieldWithEyeIcon: View {
        var placeholder: String
        @Binding var text: String
        var isSecure: Bool
        @Binding var visibility: String
        
        var body: some View {
            HStack {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
                
                Button(action: {
                    visibility = isSecure ? "visible" : "hidden"
                }) {
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
        VStack {
            Spacer()
            
            Image("logo_2")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .padding(-15.0)
            
            Text("F12 Team")
                .fontWeight(.medium)
                .font(.system(size: 8))
            
            Spacer()
            
            HStack {
                Button(action: {
                    self.showCodeField = false
                    self.showTextFields = true
                    self.selectedLoginType = .teacher
                    
                    self.buttonColorTop = buttonColorTopActive
                    self.buttonColorBottom = buttonColorBottomIdle
                    if buttonColorTop == buttonColorTopIdle {
                        buttonColorTop = Color.black
                        buttonColorBottom = Color.black
                    }
                }) {
                    VStack {
                        Text(buttonNameTop)
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
                
                Button(action: {
                    self.showTextFields = false
                    self.showCodeField = true
                    self.selectedLoginType = .student
                    
                    self.buttonColorTop = buttonColorTopIdle
                    self.buttonColorBottom = buttonColorBottomActive
                    if buttonColorBottom == buttonColorBottomIdle {
                        buttonColorTop = Color.black
                        buttonColorBottom = Color.black
                    }
                }) {
                    VStack {
                        Text(buttonNameBottom)
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
            
            if showTextFields || showCodeField {
                VStack {
                    HStack {
                        TextField("Email", text: showTextFields ? $usernameText : $studentUsernameText)
                            .padding()
                            .background(textFieldOpacity)
                            .cornerRadius(10)
                            .frame(width: 370)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .padding(.vertical, 5.0)
                    }
                    
                    HStack {
                        if buttonColorTop == Color.black {
                            if teacherPassVisibility == "visible" {
                                TextFieldWithEyeIcon(placeholder: "Password", text: $passwordText, isSecure: false, visibility: $teacherPassVisibility)
                            } else {
                                TextFieldWithEyeIcon(placeholder: "Password", text: $passwordText, isSecure: true, visibility: $teacherPassVisibility)
                            }
                        } else {
                            if studentPassVisibility == "visible" {
                                TextFieldWithEyeIcon(placeholder: "Password", text: $studentPasswordText, isSecure: false, visibility: $studentPassVisibility)
                            } else {
                                TextFieldWithEyeIcon(placeholder: "Password", text: $studentPasswordText, isSecure: true, visibility: $studentPassVisibility)
                            }
                        }
                    }
                    
                    HStack {
                        if showErrorMessages && errorMessages == "registration" {
                            Text("Incorrect Username/Password. Try again.")
                                .foregroundColor(.red)
                                .font(.caption)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            let username = (showTextFields ? usernameText : studentUsernameText).lowercased()
                            let password = (showTextFields ? passwordText : studentPasswordText)
                            
                            Task {
                                do {
                                    _ = try await AuthManager.sharedAuth.loginUser(email: username, password: password)
                                    isLoginSuccessful = true
                                    tempString = username.components(separatedBy: "@")
                                    if tempString.count > 1 && !tempString[1].isEmpty {
                                        tempString = tempString[1].components(separatedBy: ".")
                                    } else {
                                        tempString = []
                                    }
                                    tempStudentString = (tempString.count > 0 && !tempString[0].isEmpty) ? tempString[0] : ""
                                    tempStudentString == "student" ? Login.logV.setIsTeacher(false) : Login.logV.setIsTeacher(true)
                                    
                                    if isLoginSuccessful {
                                        currentLoggedInUser = username
                                        showNextView = isTeacherLogin ? .mainTeacher : .mainStudent
                                    } else {
                                        withAnimation(.easeInOut(duration: 0.05).repeatCount(4, autoreverses: true)) {
                                            shakeOffset = 6
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                                shakeOffset = 0
                                            }
                                        }
                                        performShakeAnimation()
                                        showErrorMessages = true
                                    }
                                    
                                } catch let loginUserError {
                                    showErrorMessages = true
                                    errorMessages = "Sign in of user failed.  \(loginUserError.localizedDescription)"
                                    
                                    withAnimation(.easeInOut(duration: 0.05).repeatCount(4, autoreverses: true)) {
                                        shakeOffset = 6
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                            shakeOffset = 0
                                        }
                                    }
                                    performShakeAnimation()
                                    showErrorMessages = true
                                }
                            }
                            
                            if buttonColorTop == buttonColorTopActive {
                                self.buttonColorTop = isLoginSuccessful ? buttonColorTopSucess : buttonColorLogin
                            }
                            if buttonColorBottom == buttonColorBottomActive {
                                self.buttonColorBottom = isLoginSuccessful ? buttonColorTopSucess : buttonColorLogin
                            }
                        }) {
                            Text("Login")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(width: 275, height: 20, alignment: .center)
                        }
                        .padding()
                        .background(Color.black)
                        .cornerRadius(10)
                        .offset(x: shakeOffset)
                        
                        Button(action: authenticateWithFaceID) {
                            HStack {
                                Image(systemName: "faceid")
                                    .imageScale(.large)
                                    .foregroundColor(.white)
                            }
                            .frame(width: 20, height: 20, alignment: .center)
                        }
                        .padding()
                        .background(Color.black)
                        .cornerRadius(100)
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                        }
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        Text("Don't have an account?")
                        
                        Button(action: {
                            withAnimation {
                                showNextView = .selectRegistration
                            }
                        }) {
                            Text("Sign up here!")
                                .foregroundColor(.blue)
                        }
                        Spacer()
                    }
                    .padding(.top, 10)
                }
            }
            Spacer()
            
//            Image("")
//                .resizable()
//                .scaledToFit()
                .frame(width: 150, height: 150)
            
            Spacer()
        }
    }
    
    // Authenticate with Face ID
    func authenticateWithFaceID() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        isFaceIDAuthenticated = true
                        autofillCredentials()
                    } else {
                        showAlert(title: "Authentication Failed", message: "Sorry! Could not authenticate using Face ID.")
                    }
                }
            }
        } else {
            showAlert(title: "Face ID Unavailable", message: "Sorry! Your device does not support Face ID.")
        }
    }
    
    // Autofill credentials using Face ID
    func autofillCredentials() {
        if isFaceIDAuthenticated {
            if showTextFields {
                usernameText = "h.t@sanjuan.edu"
                passwordText = "Portland0321."
            } else if showCodeField {
                studentUsernameText = "223344@student.sanjuan.edu"
                studentPasswordText = "Password123."
            }
            submitLogin()
        }
    }
    
    func submitLogin() {
        Task {
            do {
                guard let loginType = selectedLoginType else { return }
                
                var username = ""
                var password = ""
                
                switch loginType {
                case .teacher:
                    username = usernameText
                    password = passwordText
                case .student:
                    username = studentUsernameText
                    password = studentPasswordText
                }
                
               _ = try await AuthManager.sharedAuth.loginUser(email: username.lowercased(), password: password)
                
                showNextView = (loginType == .teacher) ? .mainTeacher : .mainStudent
                selectedLoginType = nil
                
            } catch {
                showAlert(title: "Login Failed", message: "Could not log in using Face ID credentials.")
                selectedLoginType = nil
            }
        }
    }
    
    func resetLoginState() {
        selectedLoginType = nil
        showTextFields = false
        showCodeField = false
        buttonColorTop = Color.black
        buttonColorBottom = Color.black
    }
    
    func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
    
    public func performShakeAnimation() {
        if let engine = try? CHHapticEngine() {
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [sharpness, intensity], relativeTime: 0)
            
            if let pattern = try? CHHapticPattern(events: [event], parameters: []) {
                if let player = try? engine.makePlayer(with: pattern) {
                    try? engine.start()
                    try? player.start(atTime: CHHapticTimeImmediate)
                }
                
                let shakes = 6
                let duration = 0.05
                
                DispatchQueue.global().async {
                    for _ in 0..<shakes {
                        DispatchQueue.main.async {
                            withAnimation(.default) { self.shakeOffset = -10 }
                        }
                        Thread.sleep(forTimeInterval: duration)
                        
                        DispatchQueue.main.async {
                            withAnimation(.default) { self.shakeOffset = 10 }
                        }
                        Thread.sleep(forTimeInterval: duration)
                    }
                    
                    DispatchQueue.main.async {
                        withAnimation(.default) { self.shakeOffset = 0 }
                    }
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    @State static private var showNextView: DisplayState = .login
    
    static var previews: some View {
        LoginView(showNextView: $showNextView)
    }
}

// Additional struct for managing the login state
internal struct Login {
    @State static private var showNextView: DisplayState = .login
    static let logV = Login()
    
    public func getIsTeacher() -> Bool {
        return isTeacherLogin
    }
    
    public func setIsTeacher(_ b: Bool) {
        isTeacherLogin = b
    }
}
