//
//  AppauseApp.swift
//  Appause
//
//  Created by Huy Tran on 4/22/24.
//

import Foundation
import SwiftUI

class ViewSwitcher: ObservableObject{
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
