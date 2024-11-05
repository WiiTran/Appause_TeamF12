//
//  StudentSettingsView.swift
//  Appause
//
//  Created by Dash on 4/19/24.
//
import SwiftUI
import FirebaseAuth

struct TeacherSettingsView: View {
    @Binding var showNextView: DisplayState
    
    @State var firstButton = "MAIN / SETTINGS"
//    @State var secondButton = "Change Password"
    @State var fourthButton = "Disable Bluetooth"
    @State var fifthButton = "Dark Mode"
    
    @EnvironmentObject var viewSwitcher: ViewSwitcher
    
    // Track the dark mode setting with @AppStorage to persist across views
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
//    // Fetch the 2FA setting for the current logged-in user
//    @State var isTwoFactorEnabled: Bool = {
//        if let user = currentLoggedInUser {
//            return UserDefaults.standard.bool(forKey: "\(user)_teacherIsTwoFactorEnabled")
//        }
//        return false
//    }()
    
    var body: some View {
        VStack {
            Button(action: { withAnimation { showNextView = .mainTeacher } }) {
                Text(firstButton)
                    .fontWeight(btnStyle.getFont())
                    .foregroundColor(btnStyle.getPathFontColor())
                    .frame(width: btnStyle.getWidth(),
                           height: btnStyle.getHeight(),
                           alignment: btnStyle.getAlignment())
            }
            .padding()
            .background(btnStyle.getPathColor())
            .cornerRadius(btnStyle.getPathRadius())
            .padding(.top)
            
            Spacer()
            
//            Button(action: {
//                viewSwitcher.lastView = "teacherSettings"
//                withAnimation { showNextView = .emailCode }
//            }) {
//                Text(secondButton)
//                    .fontWeight(btnStyle.getFont())
//                    .foregroundColor(btnStyle.getBtnFontColor())
//                    .frame(width: btnStyle.getWidth(),
//                           height: btnStyle.getHeight(),
//                           alignment: btnStyle.getAlignment())
//            }
//            .padding()
//            .background(btnStyle.getBtnColor())
//            .border(btnStyle.getBorderColor(), width: btnStyle.getBorderWidth())
//            .cornerRadius(btnStyle.getBtnRadius())
//            .padding(.bottom, 10)
//            
//            Toggle(isOn: $isTwoFactorEnabled) {
//                Text("Enable 2-Factor Authentication")
//            }
//            .onChange(of: isTwoFactorEnabled) { newValue in
//                if let user = currentLoggedInUser {
//                    UserDefaults.standard.set(newValue, forKey: "\(user)_teacherIsTwoFactorEnabled")
//                }
//            }
//            .accessibilityLabel("Enable 2-Factor Authentication")
//            .accessibilityIdentifier("Enable 2-Factor Authentication Toggle")
//            .padding()
//            
            // Dark Mode Toggle
            Button(action: {
                // Toggle the dark mode value
                isDarkMode.toggle()
                fifthButton = isDarkMode ? "Light Mode" : "Dark Mode"
            }) {
                Text(fifthButton)
                    .fontWeight(btnStyle.getFont())
                    .foregroundColor(btnStyle.getBtnFontColor())
                    .frame(width: btnStyle.getWidth(),
                           height: btnStyle.getHeight(),
                           alignment: btnStyle.getAlignment())
            }
            .padding()
            .background(btnStyle.getBtnColor())
            .border(btnStyle.getBorderColor(), width: btnStyle.getBorderWidth())
            .cornerRadius(btnStyle.getBtnRadius())
            
            Spacer()
            
            Button(action: {
                // Handle logout
                withAnimation { showNextView = .logout }
            }) {
                Text("Logout")
                    .foregroundColor(.black)
                    .fontWeight(.bold)
            }
            .padding()
            .background(Color.red)
            .cornerRadius(200)
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

struct TeacherSettingsView_Previews: PreviewProvider {
    @State static private var showNextView: DisplayState = .teacherSettings
    static var previews: some View {
        TeacherSettingsView(showNextView: $showNextView)
    }
}

