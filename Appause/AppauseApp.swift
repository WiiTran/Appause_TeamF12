//
//  AppauseApp.swift
//  Appause
//
//  Created by Luke Simoni on 4/5/24.
//

import SwiftUI

class ViewSwitcher: ObservableObject {
    @Published var lastView = ""
}

@main
struct AppauseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
