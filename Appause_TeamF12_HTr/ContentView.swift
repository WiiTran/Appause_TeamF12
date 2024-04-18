//
//  ContentView.swift
//  Appause_TeamF12_HTr
//
//  Created by Huy Tran on 4/14/24.
//

// 

import SwiftUI
enum DisplayState { case eula, login, emailCode, mainTeacher, mainStudent, selectRegistration, twoFactorAuth, verification, resetPassword
}

struct ContentView: View {
    @State private var displayState: DisplayState = .eula
    @State private var email: String = "test@example.com"
    @State private var show2FAInput: Bool = true // Add this line
    @StateObject var viewSwitcher = ViewSwitcher()
    
    var body: some View {
        VStack {
            //add DisplayState transitions here
            switch displayState {
            case .eula:
                EULAView(showNextView: $displayState)
            case .login:
                LoginView(showNextView: $displayState)
            case .mainStudent:
                StudentMainView(showNextView: $displayState)
            case .mainTeacher:
                TeacherMainView(showNextView: $displayState)
            case .selectRegistration:
                SelectRegistrationView(showNextView: $displayState)
            case .emailCode:
                ForgotPasswordView(showNextView: $displayState)
            case .resetPassword:
            ResetPasswordView(showNextView: $displayState)
            case .verification:
                pwVerificationView(showNextView: $displayState)
            case .twoFactorAuth:
                TwoFactorAuthView(showNextView: $displayState, email: email, onVerificationSuccess:
            {
                    print("Verification successful!")}, show2FAInput: $show2FAInput)

            }
        }
        //adds viewSwitcher to the views so that all views can access the values of viewSwitcher
        .environmentObject(viewSwitcher)
    }
}


struct ContentView_Previews: PreviewProvider {
    //shows the first state
    @State static private var showNextView: DisplayState = .eula
    
    static var previews: some View {
        ContentView()
    }
}
