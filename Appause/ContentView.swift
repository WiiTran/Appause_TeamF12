//
//  ContentView.swift
//  Appause
//
//  Created by Huy Tran on 4/14/24.
//

import SwiftUI

enum DisplayState {
    case eula, login, /*emailCode,*/ mainTeacher, mainStudent, /*teacherMasterControl,*/ logout, /*studentConnectCode,*/ studentSettings, teacherSettings, UnblockRequest, /*studentDeleteAdmin,*/ enrolledClass, /*studentChooseAdmin,*/ selectRegistration,/* resetPassword,*/ teacherManageUsers, teacherBlacklist, teacherWhitelist, /*twoFactorAuth,*/ /*pwCodeVerification,*/ registerClass
}


struct ContentView: View {
    @State private var displayState: DisplayState = .eula
    @State private var email: String = "test@example.com"
    @State private var show2FAInput: Bool = true
    
    // Track login status and dark mode preference
    @AppStorage("isUserLoggedIn") var isUserLoggedIn: Bool = false
    @AppStorage("isDarkMode") var isDarkMode: Bool = false

    @StateObject var viewSwitcher = ViewSwitcher()
    
    var body: some View {
        VStack {
            // DisplayState transitions
        switch displayState {
            case .eula:
                EULAView(showNextView: $displayState)
            case .login:
                LoginView(showNextView: $displayState)
            case .mainStudent:
                StudentMainView(showNextView: $displayState)
            case .mainTeacher:
                TeacherMainView(showNextView: $displayState)
//            case .studentConnectCode:
//                StudentConnectCodeView()
//            case .teacherMasterControl:
//                TeacherMasterControlView(showNextView: $displayState)
            case .logout:
                LoginView(showNextView: $displayState)
            case .studentSettings:
                StudentSettingsView(showNextView: $displayState)
            case .UnblockRequest:
                UnblockRequestView(showNextView: $displayState)
            case .teacherSettings:
                TeacherSettingsView(showNextView: $displayState)
//            case .studentChooseAdmin:
//                StudentChooseAdminView(showNextView: $displayState)
//            case .studentDeleteAdmin:
//                StudentDeleteAdminView()
            case .enrolledClass:
                enrolledClassView(showNextView: $displayState, StudentID: "sampleStudentId")
            case .teacherWhitelist:
                TeacherWhitelist()
            case .teacherBlacklist:
                TeacherWhitelist()
//            case .resetPassword:
//                ResetPasswordView(showNextView: $displayState)
            case .teacherManageUsers:
                TeacherManageUsers()
            case .registerClass:
                registerClassView(showNextView: $displayState)
            case .selectRegistration:
                SelectRegistrationView(showNextView: $displayState)
                /*
            case .emailCode:
                ForgotPasswordView(showNextView: $displayState)
            case .pwCodeVerification:
                PWCodeVerificationView(showNextView: $displayState)
            case .twoFactorAuth:
                TwoFactorAuthView(
                    showNextView: $displayState,
                    email: email,
                    onVerificationSuccess: {
                        print("Verification successful!")
                    },
                    show2FAInput: $show2FAInput
              )
                 */
        }
        }
        .preferredColorScheme(isUserLoggedIn ? (isDarkMode ? .dark : .light) : .none)
        .environmentObject(viewSwitcher)
    }
}

struct ContentView_Previews: PreviewProvider {
    @State static private var showNextView: DisplayState = .eula

    static var previews: some View {
        ContentView()
    }
}
