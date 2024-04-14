//
//  ContentView.swift
//  Appause_TeamF12_HTr
//
//  Created by Huy Tran on 4/14/24.
//

import SwiftUI
enum DisplayState { case eula, contentView }

struct ContentView: View {
    @State private var displayState: DisplayState = .eula
    var body: some View {
        VStack {
            switch displayState {
            case .eula:
         EULAView(showNextView: $displayState)
            case .contentView:
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, World!")
            }
           
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
