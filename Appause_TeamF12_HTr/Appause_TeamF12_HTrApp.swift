//
//  Appause_TeamF12_HTrApp.swift
//  Appause_TeamF12_HTr
//
//  Created by Huy Tran on 4/14/24.
//

import SwiftUI

class ViewSwitcher: ObservableObject{
    @Published var lastView = ""
}

@main
struct Appause_TeamF12_HTrApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
