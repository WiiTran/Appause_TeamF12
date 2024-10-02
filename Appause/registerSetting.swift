//
//  registerSetting.swift
//  Appause
//
//  Created by Abdurraziq on 9/30/24.
//
import SwiftUI

@main
struct SettingsApp: App { // Only one @main type
    var body: some Scene {
        WindowGroup {
            RegisterSettingView() // Your main view
        }
    }
}

struct RegisterSettingView: View {
    @State private var userName: String = ""
    @State private var password: String = ""
    @State private var faceIDEnabled: Bool = false
    @State private var bluetoothEnabled: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("User Settings")) {
                    TextField("Enter your new name", text: $userName)
                    SecureField("Enter new password", text: $password)
                    SecureField("Confirm new password", text: .constant(""))
                }
                
                Section(header: Text("Features")) {
                    Toggle("Enable Face ID", isOn: $faceIDEnabled)
                    Toggle("Enable Bluetooth", isOn: $bluetoothEnabled)
                }
                
                Button("Save Settings") {
                    saveSettings()
                }
            }
            .navigationTitle("App Settings")
        }
    }
    
    func saveSettings() {
        print("Name changed to: \(userName)")
        print("Password changed.")
        print("Face ID enabled: \(faceIDEnabled)")
        print("Bluetooth enabled: \(bluetoothEnabled)")
    }
}

  
