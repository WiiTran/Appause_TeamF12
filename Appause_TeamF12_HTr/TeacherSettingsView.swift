//
//  StudentSettingsView.swift
//  Appause_TeamF12_HTr
//
//  Created by Dash on 4/19/24.
//

import SwiftUI
import CoreBluetooth
import Combine

struct TeacherSettingsView: View {
    @Binding var showNextView: DisplayState
    
    @State var firstButton = "MAIN / SETTINGS"
    @State var secondButton = "Change Password"
    
    @State var fifthButton = "Dark Mode"
    
    @ObservedObject var bluetoothManager = BluetoothManager()
    
    @State var isBluetoothEnabled = false
    var centralManager: CBCentralManager!
    var timer: AnyCancellable?
    
    //environment variable used in navigation when the back button is pressed during the password reset process
    @EnvironmentObject var viewSwitcher: ViewSwitcher
    
    // Fetch the 2FA setting for the current logged-in student
    @State var isTwoFactorEnabled: Bool = {
        if let user = currentLoggedInUser {
            return UserDefaults.standard.bool(forKey: "\(user)_teacherIsTwoFactorEnabled")
        }
        return false
    }()

    @State private var colorScheme = btnStyle.getStudentScheme()
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                Button(action: {
                    /* sets the last page that the user was at before entering the password reset process to
                     the login page so that if the user presses the back button it brings the user
                     back to the login page. */
                    //viewSwitcher.lastView = "login"
                    withAnimation {
                        showNextView = .emailCode
                    }
                }) {
                    Text("Menu")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .frame(width: 100, height: 20, alignment: .center)
                }
                .padding()
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 10) // Apply the corner radius to the overlay
                        .stroke(Color.black, lineWidth: 1) // Add a border with 1 point width
                )
            }
            HStack {
                Spacer()
                Text("Settings")
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .font(.system(size: 40))
                    .padding()
                Spacer()
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            showNextView = .teacherChangeNameView
                        }
                    }) {
                        Text("Change Name")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 300, height: 20, alignment: .center)
                    }
                    .padding()
                    .background(Color.black)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10) // Apply the corner radius to the overlay
                            .stroke(Color.black, lineWidth: 1) // Add a border with 1 point width
                    )
                    Spacer()
                }
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            showNextView = .changePasswordView
                        }
                    }) {
                        Text("Change Password")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 300, height: 20, alignment: .center)
                    }
                    .padding()
                    .background(Color.black)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10) // Apply the corner radius to the overlay
                            .stroke(Color.black, lineWidth: 1) // Add a border with 1 point width
                    )
                    Spacer()
                }
                Spacer()
                HStack {
                    Toggle("Enable Two Factor Authentication", isOn: $isTwoFactorEnabled)
                        .padding()
                        .foregroundColor(.black)
                        .onChange(of: isTwoFactorEnabled) { newValue in
                            if let user = currentLoggedInUser {
                                UserDefaults.standard.set(newValue, forKey: "\(user)_studentIsTwoFactorEnabled")
                            }
                        }
                }
                HStack {
                    Toggle("Enable Bluetooth", isOn: $bluetoothManager.isBluetoothEnabled) // Bind to BluetoothManager
                            .padding()
                            .foregroundColor(.black)
                }
                Spacer()
            }
            .frame(maxWidth: 350, maxHeight: 400, alignment: .center)
            Spacer()
        }
        .frame(maxWidth: 350, alignment: .leading)
    }
}

struct TeacherSettingsView_Previews: PreviewProvider {
    @State static private var showNextView: DisplayState = .teacherSettingsView
    static var previews: some View {
        TeacherSettingsView(showNextView: $showNextView)
    }
}

