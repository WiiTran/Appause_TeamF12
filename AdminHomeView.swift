//
//  AdminHomeView.swift
//  Appause
//
//  Created by Rhyu Andaya on 4/11/24.
//

import SwiftUI

struct MenuButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 150)
            .padding(.vertical, 5)
            .background(Color.black)
            .foregroundStyle(.white)
            .border(Color.black)
            .position(x: 190, y: 30)
    }
}

struct LockButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.all, 10)
            .background(Color.red)
            .foregroundStyle(.black)
            .border(Color.black)
            .position(x: 145, y: 135)
    }
}

struct UnlockButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.all, 10)
            .background(Color.green)
            .foregroundStyle(.black)
            .border(Color.black)
            .position(x: 225, y: 135)
    }
}
struct AdminHomeView: View {
    @State var currentStatus = false
    var body: some View {
        ZStack {
            Color.white
            Button("Menu", action: menuScreen)
                .buttonStyle(MenuButton())
            Text("Status:")
                .foregroundColor(Color.black)
                .position(x: 190, y: 70)
            Button("Lock", action: lockStatus)
                .buttonStyle(LockButton())
            Button("Unlock", action: unlockStatus)
                .buttonStyle(UnlockButton())
            if (currentStatus == true) {
                Text("Locked")
                    .foregroundColor(Color.black)
                    .position(x: 190, y: 90)
            }
            else if (currentStatus == false) {
                Text("Unlocked")
                    .foregroundColor(Color.black)
                    .position(x: 190, y: 90)
            }
            Text("Student Connectivity")
                .padding(.horizontal, 90)
                .padding(.vertical, 5)
                .foregroundColor(Color.black)
                .border(Color.black)
                .position(x: 190, y: 200)
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(1..<31) {
                        Text("Student \($0)")
                            .padding(.vertical, 1)
                    }
                }
            }
            .foregroundColor(Color.black)
            .frame(maxWidth: 340, maxHeight: 520)
            .border(Color.black)
            .position(x: 190, y: 490)
        }
    }
    func menuScreen() {
        // go to menu
    }
    func lockStatus() {
        currentStatus = true
    }
    func unlockStatus() {
        currentStatus = false
    }
}

struct AdminHomeView_Previews: PreviewProvider {
    static var previews: some View {
        AdminHomeView()
    }
}
