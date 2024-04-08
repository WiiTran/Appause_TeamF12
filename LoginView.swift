import SwiftUI
import MessageUI
import KeychainSwift
import Combine
import CoreHaptics
import LocalAuthentication

var currentLoggedInUser: String? = nil

private var isTeacherLogin = false

struct LoginView: View {
    public var keychain = KeychainSwift()
    
    //environment variable used for switching from the forgot password screen back to the login screen
    @EnvironmentObject var viewSwitcher: ViewSwitcher
    
    // MARK: - State Variables
    @State private var show2FAInput = false
    
    // Check if two-factor authentication is enabled
    var isTwoFactorEnabled: Bool {
        if let user = currentLoggedInUser {
            let accountType = isTeacherLogin ? "teacher" : "student"
            return UserDefaults.standard.bool(forKey: "\(user)_\(accountType)IsTwoFactorEnabled")
        }
        return false
    }
    
    @State private var isFaceIDAuthenticated = false
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    @State var emailFor2FA: String = ""
    @State private var showErrorMessages = false
    @State private var errorMessages = ""
    @State private var shakeOffset: CGFloat = 0.0
    
    // Binding to control the view state
    @Binding var showNextView: DisplayState
    
    // Teacher login button properties
    @State var buttonNameTop = "Teacher"
    @State var buttonColorTopIdle = Color.gray
    @State var buttonColorTopActive = Color.black
    
    // Login button properties
    @State var buttonColorLogin = Color.black
    
    // Student login button properties
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
    
    // Password visibility
    @State var studentPassVisibility: String = ""
    @State var teacherPassVisibility: String = ""
    
    // Custom SwiftUI view to create a text field with an optional eye icon for password visibility
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
        VStack {
            if !show2FAInput {
                
                Spacer()
                
                Image("logo_2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .padding(-15.0)
                
                Text("Appause")
                    .fontWeight(.bold)
                    .font(.system(size: 36))
                
                Spacer()
                
                HStack{
                    Button(action: {
                        self.showCodeField = false
                        self.showTextFields.toggle()
                        self.buttonColorTop = self.showTextFields ? buttonColorTopActive: buttonColorTopIdle
                        self.buttonColorBottom = self.showCodeField ? buttonColorTopActive : buttonColorTopIdle
                        if(buttonColorTop == buttonColorTopIdle){
                            buttonColorTop = Color.black
                            buttonColorBottom = Color.black
                        }
                    }) {
                        // Teacher login button
                        VStack{
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
                        self.showCodeField.toggle()
                        self.buttonColorTop = self.showTextFields ? buttonColorBottomActive: buttonColorBottomIdle
                        self.buttonColorBottom = self.showCodeField ? buttonColorBottomActive : buttonColorBottomIdle
                        if(buttonColorBottom == buttonColorBottomIdle){
                            buttonColorTop = Color.black
                            buttonColorBottom = Color.black
                        }
                    }) {
                        // Student login button
                        VStack{
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
                            /*
                             Text(showTextFields ? "Teacher Username:" : "Student Username:")
                             .fontWeight(.bold)
                             */
                            
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
                                    // Use the custom TextFieldWithEyeIcon view for the teacher's password
                                    TextFieldWithEyeIcon(placeholder: "Password", text: $passwordText, isSecure: false, visibility: $teacherPassVisibility)
                                } else {
                                    // Use the custom TextFieldWithEyeIcon view for securely entering the teacher's password
                                    TextFieldWithEyeIcon(placeholder: "Password", text: $passwordText, isSecure: true, visibility: $teacherPassVisibility)
                                }
                            } else {
                                if studentPassVisibility == "visible" {
                                    // Use the custom TextFieldWithEyeIcon view for the student's password
                                    TextFieldWithEyeIcon(placeholder: "Password", text: $studentPasswordText, isSecure: false, visibility: $studentPassVisibility)
                                } else {
                                    // Use the custom TextFieldWithEyeIcon view for securely entering the student's password
                                    TextFieldWithEyeIcon(placeholder: "Password", text: $studentPasswordText, isSecure: true, visibility: $studentPassVisibility)
                                }
                            }
                        }
                        
                        // "Forgot password?" button aligned to the right
                        HStack {
                            Button(action: {
                                /* sets the last page that the user was at before entering the password reset process to
                                   the login page so that if the user presses the back button it brings the user
                                   back to the login page. */
                                viewSwitcher.lastView = "login"
                                withAnimation {
                                    showNextView = .emailCode
                                }
                            }) {
                                Text("Forgot password?")
                                    .foregroundColor(.blue)
                            }
                            .padding(.vertical, 10.0)
                            .padding(.leading, 235.0)
                        }
                        
                        HStack {
                            if showErrorMessages && errorMessages == "registration" {
                                Text("Incorrect Username/Password. Try again.")
                                    .foregroundColor(.red)
                                    .font(.caption)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                let registeredUsername = showTextFields ? keychain.get("teacherUserKey") : keychain.get("studentUserKey")
                                let registeredPassword = showTextFields ? keychain.get("teacherPassKey") : keychain.get("studentPassKey")
                                let username = (showTextFields ? usernameText : studentUsernameText).lowercased()
                                let password = (showTextFields ? passwordText : studentPasswordText)
                                let isSuccessful = username == registeredUsername && password == registeredPassword
                                
                                if isSuccessful {
                                    isTeacherLogin = showTextFields
                                    currentLoggedInUser = username
                                    if isTwoFactorEnabled {
                                        emailFor2FA = username
                                        show2FAInput = true
                                    } else {
                                        showNextView = isTeacherLogin ? .mainTeacher : .mainStudent
                                    }
                                } else {
                                    withAnimation(.easeInOut(duration: 0.05).repeatCount(4, autoreverses: true)) {
                                        shakeOffset = 6
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                            shakeOffset = 0
                                        }
                                    }
                                    performShakeAnimation()
                                }
                                
                                if (buttonColorTop == buttonColorTopActive) {
                                    self.buttonColorTop = isSuccessful ? buttonColorTopSucess : buttonColorLogin
                                }
                                
                                if (buttonColorBottom == buttonColorBottomActive) {
                                    self.buttonColorBottom = isSuccessful ? buttonColorTopSucess : buttonColorLogin
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
                            .cornerRadius(100)                            .alert(isPresented: $showAlert) {
                                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                            }
                            Spacer()
                        }
                        
                        HStack {
                            Spacer()
                            Text("Don't have an account?")
                                //.padding(.leading, 15)
                            
                            Button(action: {
                                withAnimation {
                                    showNextView = .selectRegistration
                                }
                            }) {
                                Text("Sign up here!")
                                    .foregroundColor(.blue)
                                    .padding(.leading, -4.0)
                            }
                            Spacer()
                        }
                        .padding(.top, 10)
                    }
                }
                
            } else {
                if show2FAInput {
                    TwoFactorAuthView(showNextView: $showNextView, email: emailFor2FA, onVerificationSuccess: {
                        show2FAInput = false
                        showNextView = isTeacherLogin ? .mainTeacher : .mainStudent
                    }, show2FAInput: $show2FAInput)
                }
            }
            Spacer()
            
            Image("")
                .resizable()
                .scaledToFit()
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
                usernameText = keychain.get("teacherUserKey") ?? ""
                passwordText = keychain.get("teacherPassKey") ?? ""
            } else if showCodeField {
                studentUsernameText = keychain.get("studentUserKey") ?? ""
                studentPasswordText = keychain.get("studentPassKey") ?? ""
            }
        }
    }
    
    // Show an alert with a title and message
    func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
    
    // Perform a shake animation for incorrect login attempts
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
                            withAnimation(.default) {
                                self.shakeOffset = -10
                            }
                        }
                        Thread.sleep(forTimeInterval: duration)
                        
                        DispatchQueue.main.async {
                            withAnimation(.default) {
                                self.shakeOffset = 10
                            }
                        }
                        Thread.sleep(forTimeInterval: duration)
                    }
                    
                    DispatchQueue.main.async {
                        withAnimation(.default) {
                            self.shakeOffset = 0
                        }
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
    
    // Get whether it's a teacher login
    public func getIsTeacher() -> Bool {
        return isTeacherLogin
    }
}
