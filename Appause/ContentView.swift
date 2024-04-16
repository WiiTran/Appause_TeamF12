//
//  ContentView.swift
//  Appause
//
//  Created by Luke Simoni on 4/5/24.
//  Edited by Rayanne Ohara on 4/20/2024
//

import SwiftUI

enum DisplayState {
    case login, twoFactorAuthm, pwCodeVerification, emailCode,
         resetPassword, mainStudent, mainTeacher, studentSettings,
         teacherSettings
}

struct ContentView: View {
    @State private var displayState: DisplayState = .login
    @State private var email = "test@example.com"
    @State private var show2FAInput: Bool = true
    
    @StateObject var viewSwitcher = ViewSwitcher()
    
    var body: some View {
        VStack {
            switch displayState {
            case .login:
                LoginView (showNextView: $displayState)
            case .resetPassword:
                ResetPasswordView (showNextView: $displayState)
            case .pwCodeVerification:
                PWCodeVerificationView (showNextTime: $displayState)
            case .emailCode:
                ForgotPasswordView (showNextView : $displayState)
            case .mainStudent:
                StudentMainView (showNextView : $displayState)
            case .studentSettings:
            StudentSettingsView (showNextView : $displayState)
            case .teacherSettings:
                TeacherSettingsView (showNextView : $displayState)
            case .twoFactorAuthm:
                TwoFactorAuthView(showNextView: $displayState, email: email, onVerificationSuccess: {
                    print("Verification successful")},
                        show2FAInput: $show2FAInput)
            }
        }
        .environmentObject(viewSwitcher)
    }
}
struct ContentView_Previews: PreviewProvider {
    @State static private var showNextView: DisplayState = .login
    
    static var previews: some View {ContentView()}
}
