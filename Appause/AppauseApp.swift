//
//  AppauseApp.swift
//  Appause_TeamF12_HTr
//
//  Created by Huy Tran on 9/9/24.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

/*This is an environment variable used to determine which screen the back buttons on
  EmailCodeView, PWCodeVerificationView, and ResetPasswordView take the user to*/
class ViewSwitcher: ObservableObject{
    @Published var lastView = ""
}

@main
struct Project190App: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

