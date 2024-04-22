//
//  AppauseApp.swift
//  Appause
//
//  Created by Luke Simoni on 4/5/24.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

var db = Firestore.firestore()
let doc = db.collection("Users").document("StudentAemail@gmail.com")

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
      print(doc.self)
    return true
  }
}

@main
struct AppauseApp: App {
    //register app delegate for firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
