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
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var firestoreManager = FirestoreManager() //
    @StateObject private var studentList = StudentList()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewSwitcher) // Provide as environment object
                                .environmentObject(ScheduleState.scheduleState)
                                .environmentObject(firestoreManager) // Add FirestoreManager
                                .environmentObject(studentList)
                                .environmentObject(themeManager)
                                .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
        }
    }
}
class ThemeManager: ObservableObject {
    @Published var isDarkMode: Bool = false
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
