//
//  ContentView.swift
//  AppausePl
//
//  Created by Tran Chi on 4/15/24.
//

import SwiftUI

struct MasterControlView: View {
    //State vaiable to select the app to block
    @State private var SelectApp: String = ""
    // State variable to track app lock status
    @State private var isAppLocked = false
    
   // Let apps = ["Youtube", ]
    var body: some View {
        VStack {
            Text("")
                .font(.title)
                .padding()
            
            Button(action: {
                // Call function to lock or unlock app
                self.toggleAppLock()
            }) {
                Text(isAppLocked ? "Unlock App" : "Lock App")
                    .foregroundColor(.white)
                    .padding()
                    .background(isAppLocked ? Color.green : Color.red)
                    .cornerRadius(10)
            }
        }
    }
    
    // Function to toggle app lock status
    private func toggleAppLock() {
        // Implement logic to communicate with backend service to lock or unlock app
        // For demonstration purposes, we will just toggle the state variable
        isAppLocked.toggle()
    }
}
struct MasterControlView_Previews: PreviewProvider {
    static var previews: some View {
        MasterControlView()
    }
}

