//
//  TeacherScheduleEView.swift
//  Appause
//
//  Created by user on 10/1/24.
//
import SwiftUI

struct TeacherScheduleEView: View {
    @State private var className: String = "Class Name"
    @State private var selectedPeriod = "1 Period"
    @State private var periods = ["0 Period", "1 Period", "2 Period", "3 Period", "4 Period", "5 Period", "6 Period", "7 Period"]
    @State private var time: String = "08:00 AM - 09:00 AM"

    var body: some View {
        VStack {
            TextField("Edit Class Name", text: $className)
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

            Text("Time: \(time)")
                .padding()

            HStack {
                Button(action: {
                    // Delete class action
                }) {
                    Text("Delete")
                        .foregroundColor(.red)
                }

                Spacer()

                Button(action: {
                    // Save changes action
                }) {
                    Text("Save")
                        .foregroundColor(.blue)
                }
            }
            .padding()
        }
        .navigationTitle("Edit Class")
    }
}
struct TeacherScheduleEView_Previews: PreviewProvider {
    static var previews: some View {
        TeacherScheduleEView()
    }
}
