//
//  Project190App.swift
//  Project190
//
//  Created by Vlad Puriy on 4/10/23.
//

import SwiftUI

/*This is an environment variable used to determine which screen the back buttons on
  EmailCodeView, PWCodeVerificationView, and ResetPasswordView take the user to*/
class ViewSwitcher: ObservableObject{
    @Published var lastView = ""
}



@main
struct Project190App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
