//
//  AppauseApp.swift
//  Appause
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
struct AppauseApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    private let viewSwitcher = ViewSwitcher() // Initialize ViewSwitcher here
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewSwitcher) // Provide as environment object
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
