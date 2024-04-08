//
//  ContentView.swift
//  MainTeacherPage
//
//  Created by user on 4/6/23.
//

import SwiftUI

// add aditional display states here for additional View transitions
enum DisplayState {

    case eula, login, emailCode, mainTeacher, mainStudent, teacherMasterControl, logout, studentConnectCode, studentSettings, teacherSettings, studentDeleteAdmin, studentChooseAdmin, studentRegister, teacherRegister, selectRegistration, resetPassword, teacherManageUsers, teacherWhitelist, twoFactorAuth, pwCodeVerification

}

struct ContentView: View {
    @State private var displayState: DisplayState = .eula
    @State private var email: String = "test@example.com"
    @State private var show2FAInput: Bool = true // Add this line
    
    //initializes the environment variable that comes from the Project190App file
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
            case .studentConnectCode:
                StudentConnectCodeView()
            case .teacherMasterControl:
                TeacherMasterControlView(showNextView: $displayState)
            case .logout :
                LoginView(showNextView: $displayState)
            case .studentSettings:
                StudentSettingsView(showNextView: $displayState)
            case .teacherSettings:
                TeacherSettingsView(showNextView: $displayState)
            case .studentDeleteAdmin:
                StudentDeleteAdminView()
            case .studentChooseAdmin:
                StudentChooseAdminView(showNextView: $displayState)
            case .teacherWhitelist:
                TeacherWhitelist()
            case .resetPassword:
                ResetPasswordView(showNextView: $displayState)
            case .teacherManageUsers:
                TeacherManageUsers()
            case .studentRegister:
                StudentRegisterView(showNextView: $displayState)
            case .teacherRegister:
                TeacherRegisterView(showNextView: $displayState)
            case .selectRegistration:
                SelectRegistrationView(showNextView: $displayState)
            case .emailCode:
                ForgotPasswordView(showNextView: $displayState)
            case .pwCodeVerification:
                PWCodeVerificationView(showNextView: $displayState)
            case .twoFactorAuth:
                TwoFactorAuthView(showNextView: $displayState, email: email, onVerificationSuccess: {
                    // You can add actions here that should be performed on successful verification
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
