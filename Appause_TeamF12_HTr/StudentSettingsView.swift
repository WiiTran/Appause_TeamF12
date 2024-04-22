//
//  StudentSettingsView.swift
//  Appause_TeamF12_HTr
//
//  Created by Dash on 4/19/24.
//

import SwiftUI
import CoreBluetooth
import Combine

class BluetoothManager: NSObject, CBCentralManagerDelegate, ObservableObject {
    @Published var isBluetoothEnabled = false
    private var centralManager: CBCentralManager!
    private var timer: AnyCancellable?
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        // Start a timer to check Bluetooth state periodically
        timer = Timer.publish(every: 5, on: .main, in: .default)
            .autoconnect()
            .sink { _ in
                self.checkBluetoothState()
            }
    }
    
    func checkBluetoothState() {
        let state = centralManager.state
        if state == .poweredOn {
            isBluetoothEnabled = true
        } else {
            isBluetoothEnabled = false
        }
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        // Check Bluetooth state whenever the state is updated
        checkBluetoothState()
    }
}

struct StudentSettingsView: View {
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
            return UserDefaults.standard.bool(forKey: "\(user)_studentIsTwoFactorEnabled")
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
                        showNextView = .mainStudent
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

struct StudentSettingsView_Previews: PreviewProvider {
    @State static private var showNextView: DisplayState = .studentSettingsView
    static var previews: some View {
        StudentSettingsView(showNextView: $showNextView)
    }
}

