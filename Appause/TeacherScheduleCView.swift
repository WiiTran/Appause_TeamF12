//
//  TeacherScheduleCView.swift
//  Appause
//
//  Created by user on 10/1/24.
//

import SwiftUI

import SwiftUI

struct TeacherScheduleCView: View {
    @State private var newClassName: String = ""
    @State private var selectedPeriod = "1 Period"
    @State private var periods = ["0 Period", "1 Period", "2 Period", "3 Period", "4 Period", "5 Period", "6 Period", "7 Period"]

    var body: some View {
        VStack {
            TextField("Enter Class Name", text: $newClassName)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            // Dropdown for period selection
            Picker("Select Period", selection: $selectedPeriod) {
                ForEach(periods, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()

            Button(action: {
                // Add new class action
            }) {
                Text("Add Class")
                    .font(.headline)
                    .foregroundColor(.blue)
            }
            .padding()
        }
        .navigationTitle("Add New Class")
    }
}

struct TeacherScheduleCView_Previews: PreviewProvider {
    static var previews: some View {
        TeacherScheduleCView()
    }
}
