//
//  StudentSettingsView.swift
//  Appause_TeamF12_HTr
//
//  Created by Rayanne Ohara 04/21/24
//  Purpose -------------------
//  Lay out the basic settings
//  just to implement the main view
//-----------------------------
import SwiftUI

struct StudentSettingsView: View {
    @Binding var showNextView: DisplayState
    
    @State var firstButton = "MAIN / SETTINGS"
    @State var secondButton = "Change Password"
    
    @State var fifthButton = "Dark Mode"
    
    //environment variable used in navigation when the back button is pressed during the password reset process
    @EnvironmentObject var viewSwitcher: ViewSwitcher
    
    // Fetch the 2FA setting for the current logged-in student
    @State var isTwoFactorEnabled: Bool = {
        if let user = currentLoggedInUser {
            return UserDefaults.standard.bool(forKey: "\(user)_studentIsTwoFactorEnabled")
        }
        return false
    }()

    @State private var colorScheme = btnStyle.getStudentScheme()
    
    var body: some View {
        VStack {
            Button(action: { withAnimation { showNextView = .mainStudent } }) {
                Text(firstButton)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 340,
                           height: 20,
                           alignment: .center)
            }
            .padding()
            .background(.black)
            .cornerRadius(20)
            .padding(.top)
            Spacer()
            
            Button(action: {
                /* sets the last page that the user was at before entering the password reset process to
                   the student settings page so that if the user presses the back button it brings the user
                   back to the student settings page. */
                viewSwitcher.lastView = "studentSettings"
                withAnimation { showNextView = .emailCode }
            }) {
                Text(secondButton)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(width: 340,
                           height: 20,
                           alignment: .center)
            }
            .padding()
            .background(.white)
            .border(.black, width: 5)
            .cornerRadius(10)
            .padding(.bottom, 10)
            
            Toggle(isOn: $isTwoFactorEnabled) {
                Text("Enable 2-Factor Authentication")
            }
            .onChange(of: isTwoFactorEnabled) { newValue in
                if let user = currentLoggedInUser {
                    UserDefaults.standard.set(newValue, forKey: "\(user)_studentIsTwoFactorEnabled")
                }
            }
            .padding()
            
      
           
            Button(action: {
                btnStyle.setStudentScheme()
                colorScheme = btnStyle.getStudentScheme()
                if colorScheme == 0 {
                    fifthButton = "Dark Mode"
                } else {
                    fifthButton = "Light Mode"
                }
            }) {
                Text(fifthButton)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(width: 340,
                           height: 20,
                           alignment: .center)
            }
            .padding()
            .background(.white)
            .border(.black, width: 5)
            .cornerRadius(10)
            //.padding(.bottom, 300)
            Spacer()
        }
        .preferredColorScheme(colorScheme == 0 ? .light : .dark)
    }
}

struct StudentSettingsView_Previews: PreviewProvider {
    @State static private var showNextView: DisplayState = .studentSettings
    static var previews: some View {
        StudentSettingsView(showNextView: $showNextView)
    }
}
