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
            
            Button(action: {
                /* sets the last page that the user was at before entering the password reset process to
                   the student settings page so that if the user presses the back button it brings the user
                   back to the student settings page. */
                viewSwitcher.lastView = "studentSettings"
                withAnimation { showNextView = .emailCode }
            }) {
                Text(secondButton)
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
