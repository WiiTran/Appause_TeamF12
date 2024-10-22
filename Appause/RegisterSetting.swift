
//
//  Created by Abdurraziq on 9/30/24.
//
// RegisterSettingView.swift
// Appause
//
// updated by Abdurraziq on 10/11/24.
// RegisterSettingView.swift
// Appause

import SwiftUI
import FirebaseFirestore

struct RegisterSettingView: View {
    @State private var userName: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var faceIDEnabled: Bool = false
    @State private var bluetoothEnabled: Bool = false
    @State private var showingAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("User Settings")) {
                    TextField("Enter Username", text: $userName)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)

                    SecureField("Enter new password", text: $password)
                        .textContentType(.none)
                        .autocorrectionDisabled(true)

                    SecureField("Confirm new password", text: $confirmPassword)
                        .textContentType(.none)
                        .autocorrectionDisabled(true)
                }

                Section(header: Text("Features")) {
                    Toggle("Enable Face ID", isOn: $faceIDEnabled)
                    Toggle("Enable Bluetooth", isOn: $bluetoothEnabled)
                }
                
                Button("Save Settings") {
                    saveSettings()
                }
                .foregroundColor(.blue) // Change text color to look more interactive
            }
            .navigationTitle("App Settings")
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Save Settings"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func saveSettings() {
        guard !userName.isEmpty, !password.isEmpty, password == confirmPassword else {
            alertMessage = "Please ensure all fields are filled and passwords match."
            showingAlert = true
            return
        }

        // Get a reference to the Firestore database
        let db = Firestore.firestore()
        
        // Create a dictionary to hold the user settings data
        let userSettings: [String: Any] = [
            "userName": userName,
            "password": password,
            "faceIDEnabled": faceIDEnabled,
            "bluetoothEnabled": bluetoothEnabled
        ]
        
        // Add the data to a Firestore collection called "Users" with a document ID equal to the userName
        db.collection("Users").document(userName).setData(userSettings) { error in
            if let error = error {
                alertMessage = "Error saving settings: \(error.localizedDescription)"
                showingAlert = true
            } else {
                alertMessage = "Settings successfully saved for user: \(userName)"
                showingAlert = true
                clearInputFields() // Clear the fields after saving
            }
        }
    }
    
    func clearInputFields() {
        userName = ""
        password = ""
        confirmPassword = ""
        faceIDEnabled = false
        bluetoothEnabled = false
    }
}

struct RegisterSettingView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterSettingView()
    }
}


